Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbZGBITs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbZGBITs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZGBITd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:19:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58056 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbZGBITc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:19:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=YPknA3x96ksVKGZvv43oAAz9ODx48TGvil9gD1/6/zpkYJ0R1t54/0RgGHYUEAFwN
	6F6wqc5e66xvD4GsEeQBg==
MIME-Version: 1.0
In-Reply-To: <20090702080902.GB4305@localdomain>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021057.14469.37548.stgit@menage.mtv.corp.google.com>
	 <20090702080902.GB4305@localdomain>
Date: Thu, 2 Jul 2009 01:19:30 -0700
Message-ID: <6599ad830907020119g68abedbeu19ef46f32c4f6f3d@mail.gmail.com>
Subject: Re: [PATCH 1/9] [RFC] Support named cgroups hierarchies
From: Paul Menage <menage@google.com>
To: Louis.Rilling@kerlabs.com
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 1:09 AM, Louis Rilling<Louis.Rilling@kerlabs.com> wrote:
>
> I did not see anything preventing two hierarchies from having the same
> (non empty) name.

If you try to mount with a name that matches an already existing
hierarchy, and you leave the subsystem options empty or give options
that match the existing mount, then you get the original mount; if you
specify conflicting options you get an error. I don't think the code
will let you have two hierarchies with the same non-empty name.

Paul
