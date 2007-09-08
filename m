Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbXIHTdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbXIHTdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 15:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXIHTdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 15:33:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41281 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbXIHTdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 15:33:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46E2F8B8.5020003@s5r6.in-berlin.de>
Date: Sat, 08 Sep 2007 21:32:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <20070908095008.08eb4930.randy.dunlap@oracle.com> <20070908181309.GA8647@one.firstfloor.org> <46E2EA2E.6020002@s5r6.in-berlin.de> <20070908191457.GB8647@one.firstfloor.org>
In-Reply-To: <20070908191457.GB8647@one.firstfloor.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sat, Sep 08, 2007 at 08:30:06PM +0200, Stefan Richter wrote:
>> Andi Kleen wrote:
>>> when you've been using CONFIG_IDE before it is not completely
>>> obvious you need BLK_SD for your hard disk.
>> Switching to different drivers without reading the help text?
>> Tough.
> 
> The individual driver descriptions don't say BLK_SD needs to be selected.

At least the help to CONFIG_ATA says so.

> Besides if all descriptions said that

We certainly don't want (too much) redundancy in help texts.

> the computer could as well
> do it for the user automatically. After all it's a stupid repetive
> task and computers are much better at those than humans.

In your patch, it is not the computer who finds out that the user wants
BLK_SD.  It is you who predetermined that the user wants it.
-- 
Stefan Richter
-=====-=-=== =--= -=---
http://arcgraph.de/sr/
