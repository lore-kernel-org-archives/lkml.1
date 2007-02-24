Return-Path: <linux-kernel-owner+w=401wt.eu-S933467AbXBXJwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbXBXJwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 04:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933468AbXBXJwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 04:52:17 -0500
Received: from mail.enyo.de ([212.9.189.167]:2404 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933467AbXBXJwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 04:52:16 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Samium Gromoff <_deepfire@feelingofgreen.ru>, Pavel Machek <pavel@ucw.cz>,
       Valdis.Kletnieks@vt.edu, David Wagner <daw@cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Undo some of the pseudo-security madness
References: <87r6toufpp.wl@betelheise.deep.net>
	<200701221520.l0MFKLdK032645@turing-police.cc.vt.edu>
	<871wlnq7ue.wl@betelheise.deep.net> <20070123084805.GB5560@ucw.cz>
	<87mz4996wg.wl@betelheise.deep.net>
	<20070123154127.57059632@localhost.localdomain>
Date: Sat, 24 Feb 2007 10:51:20 +0100
In-Reply-To: <20070123154127.57059632@localhost.localdomain>
	(alan@lxorguk.ukuu.org.uk's message of "Tue, 23 Jan 2007 15:41:27
	+0000")
Message-ID: <87fy8v9947.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Randomisation has nothing to do with C. In fact from a C perspective the
> compiler and linker do a lot of work to deal with ELF and loading code at
> arbitary addresses for dynamic linking and the like, not the user and
> not as language constructs. Perhaps the Lisp universe should wake up and
> meet the 1980s 8)

Uhm, C++ folks and others have run into loader performance issues due
to the way DSOs are handled.  The problem is more severe in the lisp
context because a typical image contains hundreds of thousands of
small objects on startup.
