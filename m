Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbXFLBSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbXFLBSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbXFLBSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:18:00 -0400
Received: from mga07.intel.com ([143.182.124.22]:48875 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755291AbXFLBR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:17:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="238040311"
Message-ID: <466DF3E9.30303@linux.intel.com>
Date: Mon, 11 Jun 2007 18:16:25 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
References: <20070611184146.448266229@intel.com> <20070611114839.907bcae2.kristen.c.accardi@intel.com> <20070612011148.GA9808@khazad-dum.debian.net>
In-Reply-To: <20070612011148.GA9808@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Mon, 11 Jun 2007, Kristen Carlson Accardi wrote:
>> Setting		Effect
>> ----------------------------------------------------------
>> min_power	ALPM is enabled, and link set to enter 
>> 		lowest power state (SLUMBER) when idle
>> 		Hot plug not allowed.
>>
>> max_performance	ALPM is disabled, Hot Plug is allowed
>>
>> medium_power	ALPM is enabled, and link set to enter
>> 		second lowest power state (PARTIAL) when
>> 		idle.  Hot plug not allowed.
> 
> Just some food for thought:
> 
> If you split it into a enable/disable (0/1) attribute, and a level attribute

on/off doesn't really make sense if the question is "do you favor 
power or do you favor performance".......
