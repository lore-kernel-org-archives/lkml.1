Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbXJMQfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbXJMQfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 12:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXJMQfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 12:35:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63726 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbXJMQfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 12:35:32 -0400
Message-ID: <4710F17C.8080100@oracle.com>
Date: Sat, 13 Oct 2007 09:25:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr> <20071012155708.d8abd06d.randy.dunlap@oracle.com> <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr> <47107ED2.6040509@s5r6.in-berlin.de> <Pine.LNX.4.64.0710131338330.31913@fbirervta.pbzchgretzou.qr> <4710CF9F.6080207@s5r6.in-berlin.de> <Pine.LNX.4.64.0710131609170.3348@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710131609170.3348@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 13 2007 16:01, Stefan Richter wrote:
>>> .config:176:warning: override: reassigning to symbol PREEMPT_VOLUNTARY
>>> .config:176:warning: override: PREEMPT_VOLUNTARY turns state choice

.config:176:warning: override: PREEMPT_VOLUNTARY modifies state choice

"turns" is just odd there.


>> Try to make it a single warning.
> 
> Patches welcome. Even without the patch, i.e. original kconfig
> behavior, spews two warnings. One for the symbol, and one for the choiec
> object. I do not see anything wrong with that; adding extra checks
> would perhaps only increase the code size.



-- 
~Randy
