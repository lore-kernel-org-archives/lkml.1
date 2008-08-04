Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYHDO2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYHDO2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYHDO2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:28:35 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:50950 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbYHDO2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:28:34 -0400
Date: Mon, 4 Aug 2008 16:28:32 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Elias Oltmanns <eo@nebensachen.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
Message-ID: <20080804142831.GW8749@boogie.lpds.sztaki.hu>
References: <87prp1kvyy.fsf@denkblock.local> <20080726062142.29070.10413.stgit@denkblock.local> <4892B8FE.1070400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4892B8FE.1070400@gmail.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 04:19:26PM +0900, Tejun Heo wrote:

> However, SATA or not, there simply isn't a way to abort commands in ATA.
>  Issuing random command while other commands are in progress simply is
> state machine violation and there will be many interesting results
> including complete system lockup (ATA controller dying while holding the
> PCI bus).

A system lockup may be an acceptable compromise if that saves the
hardware. Maybe the kernel should explicitely panic unless the
controller/drive is known to be able to recover.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
