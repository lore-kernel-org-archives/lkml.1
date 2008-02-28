Return-Path: <linux-kernel-owner+w=401wt.eu-S1764106AbYB1V2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764106AbYB1V2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYB1V2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:28:40 -0500
Received: from smtp-out.google.com ([216.239.33.17]:32904 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYB1V2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:28:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qIEKGghVCL6IzUWRJDVJOW9HC0ayg+4b8j6pCxQZ3Na7fo9HvQsCViroFwl60NiCy
	2fN0UiuvEDU1LJAqdX0Kg==
Message-ID: <6599ad830802281328q162d0585v3ac6b45a119a4a05@mail.gmail.com>
Date: Thu, 28 Feb 2008 13:28:31 -0800
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, xemul@openvz.org,
       pj@sgi.com
In-Reply-To: <20080228132142.4d4b1eef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
	 <20080228132142.4d4b1eef.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 1:21 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:

>
>  Because if something is in /foo/bar/cgroup/notify_on_release then
>  prefixing the filename with "cgroup_" seems pretty pointless.
>

The point would be to avoid situations where a user has code that
creates a group directory called "foo", and then in a future kernel
release cgroups introduces a control file called "foo". If it's
prefixed, then the user just has to avoid creating groups prefixed by
"cgroup." or any subsystem name, so collisions will be less likely.

Paul
