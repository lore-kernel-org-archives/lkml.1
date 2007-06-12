Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbXFLBMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbXFLBMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbXFLBL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:11:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45899 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757735AbXFLBL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:11:57 -0400
X-Sasl-enc: URNlmI2NLa2cOTS+NLStz0OVOk39EVnL2kugrTuBBJHA 1181610715
Date: Mon, 11 Jun 2007 22:11:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com, arjan@linux.intel.com
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI controllers.
Message-ID: <20070612011148.GA9808@khazad-dum.debian.net>
References: <20070611184146.448266229@intel.com> <20070611114839.907bcae2.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611114839.907bcae2.kristen.c.accardi@intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, Kristen Carlson Accardi wrote:
> Setting		Effect
> ----------------------------------------------------------
> min_power	ALPM is enabled, and link set to enter 
> 		lowest power state (SLUMBER) when idle
> 		Hot plug not allowed.
> 
> max_performance	ALPM is disabled, Hot Plug is allowed
> 
> medium_power	ALPM is enabled, and link set to enter
> 		second lowest power state (PARTIAL) when
> 		idle.  Hot plug not allowed.

Just some food for thought:

If you split it into a enable/disable (0/1) attribute, and a level attribute
(some sort of integer scale, or "min", "medium", "max" if you must use
strings.  You could use four levels to mimic the PCI device power state, for
example), it might make its usage more generic, and easier from userspace,
as it decouples the need to turn it on/off from the need to know which level
the user wants it set to when you turn it on.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
