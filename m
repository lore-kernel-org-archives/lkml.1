Return-Path: <linux-kernel-owner+w=401wt.eu-S1764716AbYD0XcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764716AbYD0XcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758544AbYD0Xb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:31:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43997 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbYD0Xb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:31:56 -0400
Message-ID: <48150CCE.6050700@zytor.com>
Date: Sun, 27 Apr 2008 16:31:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] eventfd, signalfd, timerfd, epoll_create w/flags
References: <200804272217.m3RMHZ0S021481@devserv.devel.redhat.com> <Pine.LNX.4.64.0804271614240.18184@alien.or.mcafeemobile.com> <48150BDA.5070903@redhat.com>
In-Reply-To: <48150BDA.5070903@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> 
> I used the number at the end for syscalls which aren't visible at
> userlevel.  There they are useful indicating the number of arguments.
> At userlevel I personally find it less than optimal but I'd have no
> problem changing it to epoll_create2.
> 

But surely these will have to be exposed to the user level somehow? 
There will need to be an API for this to the end user, and historically 
we have tried to keep the kernel interface as close to that as is practical.

Here you seem to suddenly be saying that there is going to be a 
completely different interface?  Why?

	-hpa
