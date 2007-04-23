Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXDWHER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXDWHER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXDWHER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:04:17 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:34526 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXDWHEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:04:15 -0400
Date: Mon, 23 Apr 2007 08:04:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Sergey Yanovich <ynvich@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Message-ID: <20070423070401.GA26428@srcf.ucam.org>
References: <4627D402.8020107@gmail.com> <20070422013411.45105.qmail@web36709.mail.mud.yahoo.com> <5a04609e0704220515h4049afas4dc98b90e66d1d16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a04609e0704220515h4049afas4dc98b90e66d1d16@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 03:15:22PM +0300, Sergey Yanovich wrote:

> For a typical, non-linux-geek user there are just two states of the device -
> available and not available. Ububtu is famous for its end-user support.
> They ship your driver since linux-2.6.17. But they pack it in one module.
> And that is _much_ easier, then a hotplug script.

No, we ship a udev script.

> At the same time, the [tifm_sd] code is device specific, and [tifm_7xx1]
> code is also device specific. And both modules depend on the same device
> (of family of devices). That makes me think that a bus/controller/slot
> construction is not going to make thing any easier, but adds complexity.

At one point it looked like it might be possible to drive the tifm_7xx0 
devices in a similar way. I'm not sure if this is actually the case, but 
right now the driver design seems to accurately reflect the reality of 
the hardware design. I don't see any especially strong argument for 
breaking that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
