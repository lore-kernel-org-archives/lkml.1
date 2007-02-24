Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbXBXJlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbXBXJlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 04:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933466AbXBXJlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 04:41:46 -0500
Received: from mail.enyo.de ([212.9.189.167]:4597 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463AbXBXJlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 04:41:45 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       David Wagner <daw-usenet@taverner.cs.berkeley.edu>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Undo some of the pseudo-security madness
References: <87r6toufpp.wl@betelheise.deep.net>
	<ep0tb0$f6e$1@taverner.cs.berkeley.edu>
	<1D317613-B0B6-4517-81B5-DBF3978FA413@mac.com>
	<87lkjvvnc6.wl@betelheise.deep.net>
Date: Sat, 24 Feb 2007 10:40:51 +0100
In-Reply-To: <87lkjvvnc6.wl@betelheise.deep.net> (Samium Gromoff's message of
	"Mon, 22 Jan 2007 04:53:29 +0300")
Message-ID: <87k5y799lo.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Samium Gromoff:

> Lisp environments can produce standalone executables

If you've got a stand-alone executable, you don't need MAP_FIXED.  The
ELF loader maps the program at a fixed address anyway (at least on
i386 and x86_64, I haven't checked others).

AFAIK, PolyML has recently made the switch to stand-alone executables
for this reason.
