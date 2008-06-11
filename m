Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYFKNxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYFKNxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 09:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYFKNw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 09:52:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39689 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYFKNw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 09:52:59 -0400
Date: Wed, 11 Jun 2008 15:52:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
In-Reply-To: <20080611063639.5e1eea5b@infradead.org>
Message-ID: <alpine.LNX.1.10.0806111552090.20733@fbirervta.pbzchgretzou.qr>
References: <200806102152.23286.solstice.dhiver@gmail.com> <20080610131314.5f7069e6@infradead.org> <484EE71A.40002@intel.com> <alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr> <20080611063639.5e1eea5b@infradead.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-06-11 15:36, Arjan van de Ven wrote:
>> >> btw this is scary; the Mhz line in /proc/cpuinfo doesn't have much
>> >> meaning really, so applications using it and depending on it is a
>> >> rather big disaster ;-(
>> >> 
>> >> Does anyone know why jackd wants to use this?
>> 
>> It would be nice to have a /sys file where the CPU frequency is in,
>
>may I ask why? What would you do with it?

Off the top off the head, just for reporting to the user. Desklets and stuff.

>If it says 100Mhz, what would you conclude? That you have a slow cpu?
>Or that you have a really fast CPU that currently runs at a low
>frequency because you're mostly idle and are saving power?
>
>CPU frequency is...
>1) not something that is fixed; it changes all the time
>2) not a good indication for performance; remember the 3.4Ghz pentium4,
>a 2Ghz Core2Duo outperforms it
>3) something which the cpu itself barely honors (the clock stops during
>idle etc etc)
