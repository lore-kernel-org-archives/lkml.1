Return-Path: <linux-kernel-owner+w=401wt.eu-S938214AbXGTBmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938214AbXGTBmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbXGTBmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:42:36 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:13302 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761080AbXGTBmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:42:35 -0400
X-Greylist: delayed 1220 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 21:42:35 EDT
Message-ID: <46A00E41.5090608@novell.com>
Date: Fri, 20 Jul 2007 10:22:09 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org
Subject: Re: i386: pata_cs5520 does not work
References: <20070716.091928.111205836.takada@mbf.nifty.com>	<20070718144212.3289e86c@the-village.bc.nu>	<20070719015806.8B09.TAKADA@mbf.nifty.com>	<20070719.190831.23015057.takada@mbf.nifty.com> <20070719161821.5206ac36@the-village.bc.nu>
In-Reply-To: <20070719161821.5206ac36@the-village.bc.nu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> O> > rc = devm_request_irq(&pdev->dev, irq[ap->port_no],
>>> 	ata_interrupt, 0, DRV_NAME, host);
>> devm_request_irq() is called twice from loop.
>> In 1st time, ap->port_no is 0. devm_request_irq() is success.
>> 2nd time, ap->port_no is 0 too. devm_request_irq() failed.
> 
> Looks like whoever updated it to the new probe mechanism didn't quite get
> it right
> 
> Change it to use 
> 
>           struct ata_port *ap = host->ports[i];
> 
> not ports[0]

Eh.... That was me being stupid.  Sorry about that.

-- 
tejun
