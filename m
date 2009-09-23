Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbZIWMXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbZIWMXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZIWMXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:23:48 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:58050 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZIWMXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ggsc0+fDsMuqW+BY/ZEPUzuFl/yJNPvjnNJ/L7pWk7hxDjXDljzPPAYqbHxH3AdDvK
         rqBLUqkradF5/GLjUCJ5Jsdlz7Mz85fmyJE4z5GjtNBw5KgnLK4M9AJApxrdXSRWOzV2
         6X8D0wD2M77sr7dDirt2SX1obeGFVk1Laop4M=
MIME-Version: 1.0
In-Reply-To: <4ABA0FDA.9090707@sbcglobal.net>
References: <4ABA0FDA.9090707@sbcglobal.net>
Date: Wed, 23 Sep 2009 08:23:51 -0400
Message-ID: <9e4733910909230523v47d1fb3fn2575ed5d8e86069c@mail.gmail.com>
Subject: Re: disk speed regression kernel 2.6.29 and after
From: Jon Smirl <jonsmirl@gmail.com>
To: whansard@sbcglobal.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 8:08 AM, will <whansard@sbcglobal.net> wrote:
> I had been using an old 2.6.22 kernel on my machine, and I often backup one
> partition of my main hard drive to a partition on a second hard drive. The
> main hard drive is sata 640 gigs, and the second is a pata 320 gig. copying
> this partition from one drive to the other with dd takes about 3 minutes and
> 30 seconds. When I installed kernel 2.6.30, and 2.6.31, the time took 9
> minutes and 20 seconds. I decided to go to the trouble of compiling all the
> kernels between, and kernels 2.6.22-2.6.28 all do the operation in about 3

Download the kernel source using git. Then use 'git bisect' to find
the exact commit that is causing problems.
'git bisect' does a binary search so it homes in on the problem commit quickly.

Once you know the exact commit it is much easier to find the problem.

> minutes and 30 seconds. 2.6.29- newer all take about 9 minutes and 20
> seconds. The partition is 16 gigs. each drive seems to be as fast as before
> otherwise, it's just much slower copying from one drive to another, which I
> do very often. This is an nforce 3 based motherboard, amd southbridge, i
> think, with 4 gigs of ram, athlon 64x2. 32 bit kernel. has anyone heard of
> this problem?
> I currently have 3  hard drives hooked up.
> a 200 gig on a promise controller,
> a 320 gig on the amd pata?
> a 640 sata on the nv i think.
> The motherboard is a Asrock-AM2NF3-VSTA
> copying this partition with dd or cat or schily's dd between any of these 3
> different hard drives takes different times depending on the speed of the
> drive with
> kernels 2.6.22-2.6.28, but takes about 9 minutes and 30 seconds on any of
> the drives
> with the kernels 2.6.29 and after.
> Please cc me with any followups or anything. thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Jon Smirl
jonsmirl@gmail.com
