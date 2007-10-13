Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbXJMOPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbXJMOPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbXJMOPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:15:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45451 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbXJMOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:15:17 -0400
Date: Sat, 13 Oct 2007 16:15:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Randy Dunlap <randy.dunlap@oracle.com>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
In-Reply-To: <4710CF9F.6080207@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0710131609170.3348@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
 <20071012155708.d8abd06d.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr>
 <47107ED2.6040509@s5r6.in-berlin.de> <Pine.LNX.4.64.0710131338330.31913@fbirervta.pbzchgretzou.qr>
 <4710CF9F.6080207@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 13 2007 16:01, Stefan Richter wrote:
>> 
>> .config:176:warning: override: reassigning to symbol PREEMPT_VOLUNTARY
>> .config:176:warning: override: PREEMPT_VOLUNTARY turns state choice
>
>Try to make it a single warning.

Patches welcome. Even without the patch, i.e. original kconfig
behavior, spews two warnings. One for the symbol, and one for the choiec
object. I do not see anything wrong with that; adding extra checks
would perhaps only increase the code size.

