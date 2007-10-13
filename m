Return-Path: <linux-kernel-owner+w=401wt.eu-S1761854AbXJMQgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761854AbXJMQgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 12:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbXJMQgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 12:36:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34214 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbXJMQga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 12:36:30 -0400
Date: Sat, 13 Oct 2007 18:36:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
In-Reply-To: <4710F17C.8080100@oracle.com>
Message-ID: <Pine.LNX.4.64.0710131836150.3348@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
 <20071012155708.d8abd06d.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr>
 <47107ED2.6040509@s5r6.in-berlin.de> <Pine.LNX.4.64.0710131338330.31913@fbirervta.pbzchgretzou.qr>
 <4710CF9F.6080207@s5r6.in-berlin.de> <Pine.LNX.4.64.0710131609170.3348@fbirervta.pbzchgretzou.qr>
 <4710F17C.8080100@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 13 2007 09:25, Randy Dunlap wrote:
> Jan Engelhardt wrote:
>> On Oct 13 2007 16:01, Stefan Richter wrote:
>> > > .config:176:warning: override: reassigning to symbol PREEMPT_VOLUNTARY
>> > > .config:176:warning: override: PREEMPT_VOLUNTARY turns state choice
>
> .config:176:warning: override: PREEMPT_VOLUNTARY modifies state choice
>
> "turns" is just odd there.

Yeah, I've put in
	("override: %s changes choice state", sym->name);
this morning.
