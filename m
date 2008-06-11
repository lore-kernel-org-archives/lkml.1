Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYFKMmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYFKMmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYFKMmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:42:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53647 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYFKMml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:42:41 -0400
Date: Wed, 11 Jun 2008 14:42:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
cc: Arjan van de Ven <arjan@infradead.org>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
In-Reply-To: <484EE71A.40002@intel.com>
Message-ID: <alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>
References: <200806102152.23286.solstice.dhiver@gmail.com> <20080610131314.5f7069e6@infradead.org> <484EE71A.40002@intel.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-06-10 22:42, Kok, Auke wrote:
>>>
>>> and it appears that /proc/cpuinfo lack the line 
>>> cpu MHz:
>> 
>> 
>> btw this is scary; the Mhz line in /proc/cpuinfo doesn't have much
>> meaning really, so applications using it and depending on it is a
>> rather big disaster ;-(
>> 
>> Does anyone know why jackd wants to use this?

It would be nice to have a /sys file where the CPU frequency is in,
but unless you have cpufreq loaded, no such file exists.
And there are quite a few processors which do not have cpufreq,
so /proc/cpuinfo is the only information (besides dmesg) where
you can read it from.
