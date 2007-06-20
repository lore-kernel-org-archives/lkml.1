Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbXFTMcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbXFTMcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 08:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760317AbXFTMch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 08:32:37 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3709 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761233AbXFTMcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 08:32:35 -0400
Date: Wed, 20 Jun 2007 14:31:56 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andi Kleen <ak@suse.de>
cc: geert@linux-m68k.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH for 2.6.22] [5/10] x86_64: Quieten Atari keyboard warnings
 in Kconfig
In-Reply-To: <20070620102333.CFC9514ACF@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0706201429100.1817@scrub.home>
References: <200706201223.443613000@suse.de> <20070620102333.CFC9514ACF@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 20 Jun 2007, Andi Kleen wrote:

> Not directly related to x86, but I got tired of seeing these warnings on every
> kconfig update when building on a non m68k box:
> 
> drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> 
> I moved the definition of ATARI_KBD_CORE into drivers/input/keyboard/Kconfig 
> so it's always seen by Kconfig.

Um, I thought it had been fixed already. (I'm a little busy with other 
things at the moment.)

> Signed-off-by: Andi Kleen <ak@suse.de>

Acked-by: Roman Zippel <zippel@linux-m68k.org>

bye, Roman
