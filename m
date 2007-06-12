Return-Path: <linux-kernel-owner+w=401wt.eu-S1751503AbXFLEBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbXFLEBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 00:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXFLEBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 00:01:21 -0400
Received: from mga06.intel.com ([134.134.136.21]:37419 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750698AbXFLEBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 00:01:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,410,1175497200"; 
   d="scan'208";a="253334607"
Message-ID: <466E1A32.90306@linux.intel.com>
Date: Mon, 11 Jun 2007 20:59:46 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Jeff Garzik <jeff@garzik.org>,
       =?ISO-8859-1?Q?Dagfinn_Ilmari_Mann?= =?ISO-8859-1?Q?s=E5ker?= 
	<ilmari@ilmari.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
References: <20070611184146.448266229@intel.com> <20070611114839.907bcae2.kristen.c.accardi@intel.com> <20070612011148.GA9808@khazad-dum.debian.net> <466DF3E9.30303@linux.intel.com> <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net>
In-Reply-To: <20070612035928.GB9808@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Mon, 11 Jun 2007, Jeff Garzik wrote:
>>>> on/off doesn't really make sense if the question is "do you favor power
>>>> or do you favor performance".......
> 
> Actually, it does if you think of it as "do you need hotplug right now or
> not?".

that's a temporary shortcoming; even with these power savings you can 
do hotplug as long as you're willing to poll for it at a reasonable 
interval and are willing to wait the time between polls for a hotplug 
to take effect..
