Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbYCGIaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbYCGIaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYCGI36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:29:58 -0500
Received: from mail.enyo.de ([212.9.189.167]:53321 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbYCGI36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:29:58 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Robert Dewar <dewar@adacore.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
       Jakub Jelinek <jakub@redhat.com>, NightStrike <nightstrike@gmail.com>,
       Olivier Galibert <galibert@pobox.com>,
       Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction  flag
References: <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com>
	<578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com>
	<47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org>
	<b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com>
	<6dc9ffc80803060743h502fc96bj6117ef87a8555c3a@mail.gmail.com>
	<47D012B4.3020104@zytor.com>
	<20080306162353.GF24887@devserv.devel.redhat.com>
	<6dc9ffc80803060858i7d4e8b56o99ff8ad301a5cc1a@mail.gmail.com>
	<47D024AA.9010300@zytor.com>
	<6dc9ffc80803060914x187049a2hb24ef501baf55601@mail.gmail.com>
	<47D0275B.4020105@adacore.com> <47D027B5.5030503@zytor.com>
	<47D0453D.5080501@adacore.com>
Date: Fri, 07 Mar 2008 09:28:26 +0100
In-Reply-To: <47D0453D.5080501@adacore.com> (Robert Dewar's message of "Thu,
	06 Mar 2008 14:25:49 -0500")
Message-ID: <87ablb545x.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Robert Dewar:

> again, in the real world, there are MANY projects that are nothing
> like this interactive when it comes to moving to new versions of
> operating systems.

Sure, but how many of those get to see software compiled with GCC 4.3?

If this has any real impact, it's more likely to show up in current
systems, where both kernel, libc and GCC are regularly updated, and GCC
happens to receive an update before the kernel.
