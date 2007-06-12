Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbXFLCnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbXFLCnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbXFLCnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:43:39 -0400
Received: from ping.uio.no ([129.240.78.2]:40169 "EHLO ping.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbXFLCni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:43:38 -0400
X-Greylist: delayed 2901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2007 22:43:38 EDT
From: ilmari@ilmari.org (Dagfinn Ilmari =?utf-8?Q?Manns=C3=A5ker?=)
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI controllers.
Organization: Program-, Informasjons- og Nettverksteknologisk Gruppe, UiO
References: <20070611184146.448266229@intel.com>
	<20070611114839.907bcae2.kristen.c.accardi@intel.com>
	<20070612011148.GA9808@khazad-dum.debian.net>
	<466DF3E9.30303@linux.intel.com>
Mail-Copies-To: nobody
Date: Tue, 12 Jun 2007 02:54:52 +0100
In-Reply-To: <466DF3E9.30303@linux.intel.com> (Arjan van de Ven's message of
	"Mon, 11 Jun 2007 18:16:25 -0700")
Message-ID: <d8jr6oikkcz.fsf@nygaard.ping.uio.no>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Exiscan-Spam-Score: -7.8 (-------)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@linux.intel.com> writes:

> Henrique de Moraes Holschuh wrote:
>> On Mon, 11 Jun 2007, Kristen Carlson Accardi wrote:
>>> Setting		Effect
>>> ----------------------------------------------------------
>>> min_power	ALPM is enabled, and link set to enter 		lowest
>>> power state (SLUMBER) when idle
>>> 		Hot plug not allowed.
>>>
>>> max_performance	ALPM is disabled, Hot Plug is allowed
>>>
>>> medium_power	ALPM is enabled, and link set to enter
>>> 		second lowest power state (PARTIAL) when
>>> 		idle.  Hot plug not allowed.
>> Just some food for thought:
>> If you split it into a enable/disable (0/1) attribute, and a level
>> attribute
>
> on/off doesn't really make sense if the question is "do you favor power
> or do you favor performance".......

How about just making it a numeric scale with 0 meaning no power saving
and then some fixed number of levels (e.g 0-9)?

-- 
ilmari
"A disappointingly low fraction of the human race is,
 at any given time, on fire." - Stig Sandbeck Mathisen
