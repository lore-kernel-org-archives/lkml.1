Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbXJMOBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbXJMOBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbXJMOBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:01:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59924 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbXJMOBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:01:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4710CF9F.6080207@s5r6.in-berlin.de>
Date: Sat, 13 Oct 2007 16:01:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr> <20071012155708.d8abd06d.randy.dunlap@oracle.com> <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr> <47107ED2.6040509@s5r6.in-berlin.de> <Pine.LNX.4.64.0710131338330.31913@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710131338330.31913@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 13 2007 10:16, Stefan Richter wrote:
>> Perhaps say
>>
>> 	warning("override: switching to choice %s", sym->name);
>>
>> if sym->name is [CONFIG_]PREEMPT_VOLUNTARY.  Or what is it?
> 
> .config:176:warning: override: reassigning to symbol PREEMPT_VOLUNTARY
> .config:176:warning: override: PREEMPT_VOLUNTARY turns state choice

Try to make it a single warning.

> Which seems correct, as PREEMPT_VOLUNTARY=y will overturn
> the previous decision.
> 
> Perhaps it should be "%s overturns state choice" ?

Sounds like "overthrows government".
-- 
Stefan Richter
-=====-=-=== =-=- -==-=
http://arcgraph.de/sr/
