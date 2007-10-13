Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbXJMIQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbXJMIQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 04:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXJMIQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 04:16:21 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49182 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbXJMIQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 04:16:20 -0400
Message-ID: <47107ED2.6040509@s5r6.in-berlin.de>
Date: Sat, 13 Oct 2007 10:16:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr> <20071012155708.d8abd06d.randy.dunlap@oracle.com> <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 12 2007 15:57, Randy Dunlap wrote:
>>On Fri, 12 Oct 2007 23:44:08 +0200 (CEST) Jan Engelhardt wrote:
>>
>>> warning("override: %s turns state choice", sym->name);
>>
>>What does that warning message mean?  I can't decipher it.
> 
> It is when the value of a "choice" kconfig object is changed, for example
> this .config excerpt:
> 
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> # CONFIG_PREEMPT_BKL is not set
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_REEMPT_VOLUNTARY=y

Perhaps say

	warning("override: switching to choice %s", sym->name);

if sym->name is [CONFIG_]PREEMPT_VOLUNTARY.  Or what is it?
-- 
Stefan Richter
-=====-=-=== =-=- -==-=
http://arcgraph.de/sr/
