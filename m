Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYENFqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYENFqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYENFql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:46:41 -0400
Received: from 1wt.eu ([62.212.114.60]:4309 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbYENFqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:46:39 -0400
Date: Wed, 14 May 2008 07:46:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080514054634.GA2645@1wt.eu>
References: <4829326A.6060808@t-online.de> <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com> <4829D345.7020909@t-online.de> <20080513194612.GV8474@1wt.eu> <482A70BC.3010607@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482A70BC.3010607@t-online.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 06:55:24AM +0200, Harald Dunkel wrote:
> Willy Tarreau wrote:
> >
> >even as root ? Because if you run strace on "su" as a user, you will
> >lose the setuid which may change the conditions.
> >
> 
> It gets stuck _only_ if I am root. Running su without root permission
> is no problem.

OK. That's quite strange.

> As written before, If I kick out the "stty intr '^C'" from root's
> .bashrc, then the second su succeeds. Running the stty command
> manually in this new shell is no problem.
> 
> Can you reproduce this problem? It doesn't need XWindow or any
> special user. Simply login as root on tty2, and run "su". If it
> gets stuck, then you could login on tty3 and kill -9 ### the blocking
> stty.

I tried (I'm on 2.6.25.1). But neither "su", "su willy" nor "stty intr ^C"
caused such a problem unfortunately.

You may want to ask several people to test in the same environment as
yours (same distro, etc...) in order to find whether it's a user-land
bug or a kernel bug. Most likely it's a kernel bug or side effect which
is triggered by your version of su or stty.

> Regards
> 
> Harri

Willy

