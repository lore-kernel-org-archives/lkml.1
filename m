Return-Path: <linux-kernel-owner+w=401wt.eu-S1765369AbYBVTGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765369AbYBVTGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758302AbYBVTGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:06:18 -0500
Received: from gw.goop.org ([64.81.55.164]:36225 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019AbYBVTGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:06:16 -0500
Message-ID: <47BF1C96.1060100@goop.org>
Date: Fri, 22 Feb 2008 11:03:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: Implement getgeo for Xen virtual block device.
References: <47BDE731.60801@goop.org> <alpine.LFD.1.00.0802211315190.19896@woody.linux-foundation.org> <47BDEA5E.4070800@goop.org> <alpine.LFD.1.00.0802211337220.19896@woody.linux-foundation.org> <p73lk5d89ra.fsf@bingen.suse.de> <alpine.LFD.1.00.0802220827520.19896@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802220827520.19896@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> This isn't a problem with things like "Signed-off-by:" etc tags, because 
> they have no automated meaning and don't really change the commit itself, 
> but the "From:"/"Date:"/"Subject:" markers at the head of the message 
> really do have real meaning, and get removed from the commit message and 
> instead get put into the SCM headers.
>   

It may be worth having a definitive and unambiguous Author: tag then, 
which can appear among Signed-off-by:s and is used in preference to 
anything else.  From: is a useful heuristic which seems to work well in 
general, but as you say, it gets a bit hairy when you have something 
which means different things to different parts of the software stack at 
the same time.

    J
