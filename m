Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYGENPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYGENPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 09:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYGENPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 09:15:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49774 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYGENPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 09:15:07 -0400
Date: Sat, 5 Jul 2008 15:15:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Ben Dooks <ben-linux@fluff.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig question - multiple entries touching one integer
In-Reply-To: <20080704100829.GC24620@fluff.org.uk>
Message-ID: <alpine.LNX.1.10.0807051514220.28765@fbirervta.pbzchgretzou.qr>
References: <20080704100829.GC24620@fluff.org.uk>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-07-04 12:08, Ben Dooks wrote:
>
>doing
>
>	config ARCH_EXTRA_RESOURCES
>	int
>	default 0
>	default 32 if BOARD_A
>	default 64 if BOARD_B
>
>doesn't work

The construct does work, config PAGE_OFFSET in arch/x86/Kconfig
uses it, though the order is different (the base default is last).
