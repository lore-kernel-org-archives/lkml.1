Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYEXEqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYEXEqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 00:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYEXEqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 00:46:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50781 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYEXEqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 00:46:11 -0400
Date: Sat, 24 May 2008 06:46:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Woodhouse <dwmw2@infradead.org>
cc: Adrian Bunk <bunk@kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
Subject: Re: crossbuild fails in modpost
In-Reply-To: <1211587126.31212.50.camel@shinybook.infradead.org>
Message-ID: <alpine.LNX.1.10.0805240644350.19084@fbirervta.pbzchgretzou.qr>
References: <482C3E3E.9090204@gmail.com> <482C6F02.1000205@gmail.com>  <20080515173539.GA23959@uranus.ravnborg.org>  <20080515174015.GA24024@uranus.ravnborg.org> <482C8CBE.2060101@gmail.com>  <20080515204632.GG1936@cs181133002.pp.htv.fi> 
 <alpine.LNX.1.10.0805182155011.15590@fbirervta.pbzchgretzou.qr>  <20080518204258.GL8140@cs181133002.pp.htv.fi>  <alpine.LNX.1.10.0805182314450.15590@fbirervta.pbzchgretzou.qr> <1211587126.31212.50.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-05-24 01:58, David Woodhouse wrote:

>On Sun, 2008-05-18 at 23:15 +0200, Jan Engelhardt wrote:
>> Of course not. Ever since the arch unification, building for the
>> other bitness in bi- or multiarch systems has become harder.
>
>It works fine for the unified powerpc tree.

That is good for ppc. But for x86, things seem to have changed.

Previously, one could just do `make ARCH=x86_64` on an i586
installation, now the required magic is a little bit tougher,
unless I am missing something (new).
