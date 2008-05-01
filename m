Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYEAGZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYEAGZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 02:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYEAGZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 02:25:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58314 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbYEAGZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 02:25:26 -0400
Date: Thu, 1 May 2008 08:25:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <rpurdie@rpsys.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
In-Reply-To: <20080501023642.GA7063@anvil.corenet.prv>
Message-ID: <alpine.LNX.1.10.0805010824090.5623@fbirervta.pbzchgretzou.qr>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net> <20080430202013.GB14164@elte.hu> <20080430163924.ZZRA012@mailhub.coreip.homeip.net> <20080430212029.GA28813@elte.hu> <20080430222645.GB2629@anvil.corenet.prv>
 <20080430223828.GA31878@elte.hu> <20080430224701.GC2629@anvil.corenet.prv> <Pine.LNX.4.64.0805010213530.30555@scrub.home> <20080501023642.GA7063@anvil.corenet.prv>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-01 04:36, Dmitry Torokhov wrote:
>
>BTW, does this mean that all 'if'-guarded symbols should be converted to
>this style?
>
No, because all symbols inside an "if FOO" block just means they
have a "depends on FOO". So other than saving some typing, it
does nothing. Well, perhaps it _ensures_ that all objects are
properly put _into_ the menuconfig. Some people get this wrong
and use "depends on FOO" inconsistently, leading to options
"falling" out of the menu, i.e. reappear at the parent menu.
