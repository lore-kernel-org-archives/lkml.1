Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbZDEMzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbZDEMzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 08:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZDEMzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 08:55:33 -0400
Received: from lucidpixels.com ([75.144.35.66]:48148 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZDEMzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 08:55:32 -0400
Date: Sun, 5 Apr 2009 08:55:27 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: kernel/console beep no longer available, audio problems
 too
In-Reply-To: <alpine.DEB.2.00.0904050756050.20631@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0904050852240.22989@p34.internal.lan>
References: <alpine.DEB.2.00.0904050756050.20631@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Apr 2009, Justin Piszcz wrote:

> Hello,
>
> After upgrading from 2.6.28.2, I noticed 2.6.29.1 (the config option moved 
> around too for the PC-speaker) that the audio for my sound card does not 
> start working for 1-2 minutes after trying to play various sounds. 
> Eventually, it starts to work, but the PC speaker no longer functions.
>
> http://home.comcast.net/~jpiszcz/20090405/2.6.29.1-cfg.txt
> http://home.comcast.net/~jpiszcz/20090405/2.6.28.2-cfg.txt
>
> Is this a kernel/configuration issue or a bug since it appears the audio 
> hw/configuration has been re-worked?
>
> Justin.
>

Pardon the noise:

2009-04-05 06:05:39 configure xterm 242-1 242-1
2009-04-05 06:05:39 status unpacked xterm 242-1
2009-04-05 06:05:39 status unpacked xterm 242-1
2009-04-05 06:05:39 status unpacked xterm 242-1
2009-04-05 06:05:39 status unpacked xterm 242-1
2009-04-05 06:05:39 status unpacked xterm 242-1
2009-04-05 06:05:39 status half-configured xterm 242-1
2009-04-05 06:05:40 status installed xterm 242-1

The problem is the new xterm in debian testing, it has a bug, reporting it 
now, all seems good so far with 2.6.29.1.

(going back to xterm 235_2 fixes the beep problem):
http://debian.oregonstate.edu/debian/pool/main/x/xterm/xterm_235-2_i386.deb

Justin.
