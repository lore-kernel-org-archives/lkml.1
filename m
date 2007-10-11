Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbXJKQYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbXJKQYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 12:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXJKQYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 12:24:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38860 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbXJKQYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:24:40 -0400
Date: Thu, 11 Oct 2007 18:24:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rob Landley <rob@landley.net>, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Message-ID: <20071011162458.GA10142@uranus.ravnborg.org>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710110923470.23818@anakin> <20071011113931.GB8393@uranus.ravnborg.org> <Pine.LNX.4.64.0710111443530.3729@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710111443530.3729@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > 2) suggested functionality makes it easy to do make headers_install
> 
> This is something completely different (cfr. the other thread handling
> it). If `make headers_install' doesn't need the cross compiler, it
> should not try to execute it.

This is obviously correct.
It happens that we execute gcc several times for just about any target
due to the:
CFLAGS += $(call cc-option, xxx)

And refactoring the top-level Makefile to avoid this is on my TODO list.
But it is a major crunch to do correct...

The primary objective to do so is btw not to solve this issue but
more to get the top-level Makefile off the top-10 list of the most
ureadable unmaitaninable unhackable code in the kernel.

	Sam
