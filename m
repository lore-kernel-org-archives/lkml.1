Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbYFDDQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbYFDDQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYFDDQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 23:16:41 -0400
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:4651 "EHLO
	anchor-post-35.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbYFDDQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 23:16:40 -0400
Message-ID: <48460906.2080205@lougher.demon.co.uk>
Date: Wed, 04 Jun 2008 04:16:22 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: squashfs-devel@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Squashfs mainlining status?
References: <Pine.LNX.4.64.0806021650190.28709@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0806021650190.28709@vixen.sonytel.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> 	Hi Phillip,
> 
> I was wondering what's the status of mainlining squashfs?
> Is there anything I can do to help?
> 

I am currently working on this.  A re-write and merge of the Squashfs 
metadata and fragment cache code has been finished (it is in the 
Squashfs CVS tree).  The original implementation had a number of 
performance issues which I wanted to address before resubmission.

The major work of course is the move to a little endian layout without 
any bit fields in the structures to make it easier to swap member fields 
on big-endian architectures.  I'm currently working on this on a non-CVS 
branch.  Most of the work till now has been without any attempt to 
retain backwards compatibility with the current 3.3 little-endian 
filesystem layout.   After your private email regarding retaining 
backwards compatibility I will look again at this issue, it may well be 
that I will abandon my current layout changes that I have so far made.

I have taken time off work to work on the necessary mainline changes 
full time (unpaid unfortunately, so I need to look for another job 
soon).  Hopefully this will mean I will make better progress than I have 
been able to in the last couple of years.

Phillip
