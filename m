Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbYCGMIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbYCGMIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYCGMIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:08:21 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:15967 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYCGMIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C845TUWqvz32noIWXsIUJci76qqBZgeHsnjfoBC/DcikwQSa7mcP51mq+D0FKrODb127LyGhjgpwqjmLwkdUcG5Ss+e68aYPPf4Av/+RQgbiVqL8kZ4oT+owuIec7IxZ8zXK2BrRgTuSmEnwfHmfQuz3salGCvBImB7IZzX60OA=
Message-ID: <e2e108260803070408l4600ae4cx1ecd261318cb63c6@mail.gmail.com>
Date: Fri, 7 Mar 2008 13:08:20 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: 7eggert@gmx.de
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of the disk image
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Laurent Vivier" <Laurent.Vivier@bull.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1JXbBo-0000ix-57@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <a4kTW-44U-25@gated-at.bofh.it> <a4l3D-4hn-11@gated-at.bofh.it>
	 <a4lmN-4Xt-7@gated-at.bofh.it> <a4m9d-6iD-7@gated-at.bofh.it>
	 <E1JXbBo-0000ix-57@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2008 at 12:56 PM, Bodo Eggert <7eggert@gmx.de> wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>  > On Thursday 06 March 2008 21:16, Laurent Vivier wrote:
>  >> Le jeudi 06 mars 2008 à 20:57 +1100, Nick Piggin a écrit :
>
>  >> > Do you think we do something similar for drivers/block/brd.c too? I'd
>  >> > like to try to maintain parity between them where possible...
>  >>
>  >> I think it is possible  (I've the same patch for NBD too), but I think
>  >> it is completely useless.
>  >
>  > It's useful for testing, and for minimising the divergence in the
>  > code.
>
>  Maybe there should be a common mechanism to use partitions on any block
>  device. Maybe there is - I have dark memories about the device mapper
>  being able to parse partition tables, and plans on moving partition
>  support to userspace.

It's easy to add partition support to the loopback device. A patch
that realizes this was already published in 2004. See also
http://lwn.net/Articles/110426/.

Bart Van Assche.
