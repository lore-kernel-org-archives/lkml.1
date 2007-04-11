Return-Path: <linux-kernel-owner+w=401wt.eu-S1030715AbXDKBMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030715AbXDKBMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 21:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030317AbXDKBMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 21:12:07 -0400
Received: from mx.pathscale.com ([198.186.3.68]:40467 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030715AbXDKBMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 21:12:06 -0400
X-Greylist: delayed 1436 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2007 21:12:06 EDT
Message-ID: <461C3063.9010603@pathscale.com>
Date: Tue, 10 Apr 2007 17:48:35 -0700
From: Robert Walsh <rjwalsh@pathscale.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
Cc: "Bryan O'Sullivan" <bos@pathscale.com>, openib-general@openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Re: [PATCH 00 of 33] Set of ipath patches for 2.6.22
References: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>	<aday7kzooa7.fsf@cisco.com> <adahcrnoiie.fsf@cisco.com>
In-Reply-To: <adahcrnoiie.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > Is there any chance of getting a fix for the use-after-free that can
>  > be caused by allocating something from userspace, failing to mmap the
>  > buffer and then exiting?  To see what happens, look at how
>  > ipath_create_cq sticks a struct ipath_mmap_info into the pending mmap
>  > "list" (and yes it would be much cleaner to just use struct list_head
>  > here rather than reimplementing a linked list yourself), and then look
>  > at how ipath_destroy_cq() frees the same structure without checking if
>  > it has been removed from the pending mmap list.
> 
> By the way, would it help get this fixed if I opened a bug on openfabrics.org?
> Or is that a waste of time?

We're tracking it here (bug 12010 on our internal bugzilla), and it's on 
my list to get done "soon".  I'm currently in the middle of some other 
bug fixes, but when I get to a good stopping point, I'll get this fixed. 
  Shouldn't be too difficult.

If you'd like to track it yourself, feel free to open an OpenFabrics 
bug.  I'll update the bug when I get a patch done.

Regards,
  Robert.
