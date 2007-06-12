Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbXFLB75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbXFLB75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbXFLB7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:59:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50658 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469AbXFLB7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:59:44 -0400
Message-ID: <466DFE09.3020408@garzik.org>
Date: Mon, 11 Jun 2007 21:59:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Dagfinn_Ilmari_Manns=E5ker?= <ilmari@ilmari.org>
CC: Arjan van de Ven <arjan@linux.intel.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
References: <20070611184146.448266229@intel.com>	<20070611114839.907bcae2.kristen.c.accardi@intel.com>	<20070612011148.GA9808@khazad-dum.debian.net>	<466DF3E9.30303@linux.intel.com> <d8jr6oikkcz.fsf@nygaard.ping.uio.no>
In-Reply-To: <d8jr6oikkcz.fsf@nygaard.ping.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dagfinn Ilmari Mannsåker wrote:
> Arjan van de Ven <arjan@linux.intel.com> writes:
> 
>> Henrique de Moraes Holschuh wrote:
>>> On Mon, 11 Jun 2007, Kristen Carlson Accardi wrote:
>>>> Setting		Effect
>>>> ----------------------------------------------------------
>>>> min_power	ALPM is enabled, and link set to enter 		lowest
>>>> power state (SLUMBER) when idle
>>>> 		Hot plug not allowed.
>>>>
>>>> max_performance	ALPM is disabled, Hot Plug is allowed
>>>>
>>>> medium_power	ALPM is enabled, and link set to enter
>>>> 		second lowest power state (PARTIAL) when
>>>> 		idle.  Hot plug not allowed.
>>> Just some food for thought:
>>> If you split it into a enable/disable (0/1) attribute, and a level
>>> attribute
>> on/off doesn't really make sense if the question is "do you favor power
>> or do you favor performance".......
> 
> How about just making it a numeric scale with 0 meaning no power saving
> and then some fixed number of levels (e.g 0-9)?

The original proposal seems far more intuitive than these alternatives.

	Jeff



