Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbYFKXJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbYFKXJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYFKXI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:08:58 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:13961 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYFKXI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:08:57 -0400
To: markh@compro.net
Cc: Arjan van de Ven <arjan@infradead.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
From: Andi Kleen <andi@firstfloor.org>
References: <200806102152.23286.solstice.dhiver@gmail.com>
	<20080610131314.5f7069e6@infradead.org> <484EE71A.40002@intel.com>
	<alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>
	<20080611063639.5e1eea5b@infradead.org>
	<alpine.LNX.1.10.0806111552090.20733@fbirervta.pbzchgretzou.qr>
	<20080611065816.6cff290d@infradead.org>
	<Pine.LNX.4.61.0806111006560.23096@chaos.analogic.com>
	<20080611083644.32afc823@infradead.org> <4850046C.4070602@compro.net>
	<20080611104446.3b0ce2d9@infradead.org> <48501159.4050908@compro.net>
Date: Thu, 12 Jun 2008 01:08:55 +0200
In-Reply-To: <48501159.4050908@compro.net> (Mark Hounschell's message of "Wed, 11 Jun 2008 13:54:33 -0400")
Message-ID: <8763sfpo1k.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Jun 2008 23:01:43.0647 (UTC) FILETIME=[1DCEDEF0:01C8CC17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell <markh@compro.net> writes:
>
> OK. If I am always using AMD Opteron/X64 class machines am I safe here
> when no cpu freq scaling stuff is on and I'm pinned to a particular processor?

It depends on what you want to be safe against, but if you mean
"RDTSC output has an ongoing stable frequency matching your wall clock with a constant
factor" then no, you won't be safe.

-Andi
