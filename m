Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbYAVHRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbYAVHRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 02:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYAVHRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 02:17:06 -0500
Received: from ozlabs.org ([203.10.76.45]:47386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbYAVHRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 02:17:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] RFC: Typesafe callbacks
Date: Tue, 22 Jan 2008 18:16:19 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <200801202046.14746.rusty@rustcorp.com.au> <200801221027.15002.rusty@rustcorp.com.au> <alpine.LFD.1.00.0801211547160.2957@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801211547160.2957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801221816.19594.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2008 10:57:03 Linus Torvalds wrote:
> On Tue, 22 Jan 2008, Rusty Russell wrote:
> > Attempt to create callbacks which take unsigned long as well as
> > correct pointer types.
>
> I bow down before you.
>
> I thought I had done some rather horrible things with gcc built-ins and
> macros, but I hereby hand over my crown to you.
>
> As my daughter would say: that patch fell out of the ugly tree, and hit
> every branch on the way down. Very impressive.
>
> All hail Rusty, undisputed ruler of Ugly-land.

Err, thanks.  I read some old SCSI drivers and felt inspired...

> Side note: can you verify that __builtin_choose_expr() exists in gcc-3? I
> don't think we've relied on it before except on arm, and that one has
> always had its own compiler version dependencies..

    Hmm, looks like not in 3.0.4, is in 3.1.1.  I'll make it appropriately  
#ifdef'ed (which as a bonus will make things that little bit uglier still...)

    If we can stomach it the effect is nice, but the version which simply 
allows pointer correctness (rather than trying to do unsigned long too) is 
less bletcherous.

Thanks,
Rusty.
