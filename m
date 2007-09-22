Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbXIVJqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbXIVJqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXIVJqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:46:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46288 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXIVJqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:46:45 -0400
Date: Sat, 22 Sep 2007 11:46:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
       oliver.pntr@gmail.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/50] x86: add cpu codenames for Kconfig.cpu
In-Reply-To: <20070922065724.GA26550@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0709221145300.15712@fbirervta.pbzchgretzou.qr>
References: <200709221231.836138000@suse.de> <20070921223202.2504813DCD@wotan.suse.de>
 <20070921224539.GD8127@redhat.com> <20070922065724.GA26550@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 22 2007 08:57, Sam Ravnborg wrote:
>> 
>> This seems like yet another list that will need to be perpetually
>> kept up to date, and given 99% of users don't know the codename
>> of their core, just the marketing name, I question its value.
>
>As a bare minimum requirement the list presented here shall use same
>names as used in /proc/cpuinfo
>
>On this box I read:
>
>vendor_id	: GenuineIntel
>model name	: Pentium III (Coppermine)
>
>This info must be present in Kconfig text (help text) too.
>I always have trouble selecting the right CPU before so I welcome this patch
>that give me more info - and maybe a bit too much.

model name      : AMD Athlon(tm) XP 2000+

here. Seems like Intel encodes their codenames into cpuid :(
