Return-Path: <linux-kernel-owner+w=401wt.eu-S1762370AbYEFJGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762370AbYEFJGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764418AbYEFJD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:03:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35394 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764393AbYEFJD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:03:57 -0400
Date: Tue, 6 May 2008 11:03:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kconfig: make oldconfig less chatty and clean up
 conf.c
In-Reply-To: <Pine.LNX.4.64.0805060455590.30555@scrub.home>
Message-ID: <alpine.LNX.1.10.0805061103090.16731@fbirervta.pbzchgretzou.qr>
References: <20080502204729.GA6534@uranus.ravnborg.org> <20080504185737.GA23063@uranus.ravnborg.org> <20080504185950.GC23063@uranus.ravnborg.org> <Pine.LNX.4.64.0805060455590.30555@scrub.home>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-05-06 05:08, Roman Zippel wrote:
>
>I strongly disagree with this, please preserve the old behaviour. It took 
>a while to work out the current behaviour.
>Only silentoldconfig checks for stdin because it's used as hook during 
>kbuild to verify the config. For all other interactive targets the user 
>has to know what he's doing, e.g. it's valid to do "yes '' | make 
>oldconfig".

Noting that `yes | make oldconfig` is often not the right thing anyway
(you want modules most of the time) or does not even work (things
that can only be modules [M/n] cannot take y).

