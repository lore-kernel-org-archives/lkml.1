Return-Path: <linux-kernel-owner+w=401wt.eu-S1763125AbYCSWYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763125AbYCSWYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965200AbYCSVCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:02:13 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:23509 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048AbYCSVCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:02:12 -0400
Message-ID: <47E087DF.7070101@gmail.com>
Date: Wed, 19 Mar 2008 12:26:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803181159.48327.volker.armin.hemmann@tu-clausthal.de> <47DFBBE2.7050304@gmail.com> <200803181433.12584.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200803181433.12584.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Volker Armin Hemmann wrote:
> On Dienstag, 18. März 2008, Tejun Heo wrote:
>>  failed message on reboots).
>>
>>> Of course, I booted and rebooted several times. And it stays.
>>>
>>> Maybe it is the hardware. But I replaced the cables already and smart
>>> says the disk is ok.
>> Does the attached patch make any difference?
> 
> patching file drivers/ata/ahci.c
> Hunk #1 succeeded at 397 (offset -5 lines).
> Hunk #2 succeeded at 1819 (offset -45 lines).

It's okay.  It's because I was lazy and generated the patch against
devel tree.

> built&booted, same results as allways. With non-raid setting, IDENTIFY error 
> on cold boot and sofreset error on reboot:
> (with patch, without nosmi):

Oh... I see.  I made a mistake.  In ahci.c, what I intended was making
ahci_softreset NULL not ahci_hardreset.  Can you please change that and
test again?

-- 
tejun
