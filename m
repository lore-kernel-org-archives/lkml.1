Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYJ3G7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYJ3G7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 02:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYJ3G7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 02:59:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44042 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbYJ3G7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 02:59:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=A6YtOATG3w9MVgIvrA9jaK1pdCcWJstpEzoyyM+0YvIMc4YP2GT16Sdw4xTVEx5lb
	uvATsbj7+PRIWYQG45aKA==
Message-ID: <6599ad830810292359u6a2d0191ud235b866a73a7359@mail.gmail.com>
Date: Wed, 29 Oct 2008 23:59:02 -0700
From: "Paul Menage" <menage@google.com>
To: "David Rientjes" <rientjes@google.com>
Subject: Re: [patch 6/7] cpusets: per cpuset dirty ratios
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Peter Zijlstra" <peterz@infradead.org>, "Derek Fults" <dfults@sgi.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810280302320.15270@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0810280302320.15270@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 9:08 AM, David Rientjes <rientjes@google.com> wrote:
> From: Christoph Lameter <cl@linux-foundation.org>
>
> This implements dirty ratios per cpuset.  Two new files are added to the
> cpuset directories:

Wouldn't this be equally applicable to cgroups using the memory
controller rather than cpusets? Might it make sense to have a common
subsystem that could be used by either of them?

Paul
