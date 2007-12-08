Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbXLHVVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbXLHVVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 16:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXLHVVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 16:21:23 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48074 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbXLHVVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 16:21:22 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <475B0AC7.2030408@s5r6.in-berlin.de>
Date: Sat, 08 Dec 2007 22:21:11 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Nick Warne <nick@ukfsn.org>
CC: Clemens Koller <clemens.koller@anagramm.de>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: scsi_wait_scan Kconfig option
References: <20071207191242.71a9cc3e@linuxamd.linicks.net>	<475A9810.4070104@anagramm.de> <20071208162122.7e77601e@linuxamd.linicks.net>
In-Reply-To: <20071208162122.7e77601e@linuxamd.linicks.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Clemens Koller <clemens.koller@anagramm.de> wrote:
>> Nick Warne schrieb:
>>> I am bringing this up again - primarily as I forgot about it after
>>> patching my build tree ages ago:
>>>
>>> http://lkml.org/lkml/2007/10/27/68

>> Please see the patch I sent some days ago, which does the very
>> same thing: http://marc.info/?l=linux-kernel&m=119677244318528&w=2

Besides, in order for scsi_wait_scan to work, drivers need to support it
explicitly, don't they?  If so, simply kill the "default m" from config
SCSI_WAIT_SCAN and let any driver which is integrated with it select it.

(Not that I'm a friend of select, but here is a case where it won't hurt
too much.)
-- 
Stefan Richter
-=====-=-=== ==-- -=---
http://arcgraph.de/sr/
