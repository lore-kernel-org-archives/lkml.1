Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbXDVRWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbXDVRWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 13:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbXDVRWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 13:22:53 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbXDVRWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 13:22:52 -0400
Date: Sun, 22 Apr 2007 10:22:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Junio C Hamano <junkio@cox.net>
cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.1.2
In-Reply-To: <7v1widrl0o.fsf@assigned-by-dhcp.cox.net>
Message-ID: <alpine.LFD.0.98.0704221019100.9964@woody.linux-foundation.org>
References: <7vhcrml4wx.fsf@assigned-by-dhcp.cox.net>
 <7v1widrl0o.fsf@assigned-by-dhcp.cox.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 Apr 2007, Junio C Hamano wrote:
>
> The latest maintenance release GIT 1.5.1.2 is available at the
> usual places:

Well, by "available" you probably mean "not available", because it doesn't 
actually work.

I get EPERM on pack-e00affefe0f779d0f9b0507aef25a1733f4a9117.idx/pack, 
because they are

	-r-------- 1 junio junio  1120880
	-r-------- 1 junio junio 15709370

respectively.

As a result, nothing really works, ie:

	[torvalds@hera git.git]$ git log
	error: Could not read 42c4b58059fa9af65e90f2c418bb551e30d1d32f

and doing a "git pull" will just result in lots of

	error: refs/heads/maint does not point to a valid object!
	error: refs/heads/next does not point to a valid object!
	error: refs/heads/todo does not point to a valid object!
	...

which is perhaps a bit of a misleading error message (technically true, 
but ..)

Oops.

		Linus
