Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXKDMsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXKDMsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 07:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbXKDMsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 07:48:15 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20701 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbXKDMsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 07:48:14 -0500
Message-ID: <472DBF8C.2060508@msgid.tls.msk.ru>
Date: Sun, 04 Nov 2007 15:48:12 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> # ps auxww | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]
> 
> After several days/weeks, this is the second time this has happened,
> while doing regular file I/O (decompressing a file), everything on the
> device went into D-state.

The next time you come across something like that, do a SysRq-T dump and
post that.  It shows a stack trace of all processes - and in particular,
where exactly each task is stuck.

/mjt
