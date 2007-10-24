Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbXJXDR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbXJXDR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXJXDRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:17:50 -0400
Received: from animx.eu.org ([216.98.75.249]:38699 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXJXDRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:17:49 -0400
Date: Tue, 23 Oct 2007 23:17:39 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How do I get my aic94xx to see sata drives?
Message-ID: <20071024031739.GA6546@animx.eu.org>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	linux-kernel@vger.kernel.org
References: <20071024022124.GA6226@animx.eu.org> <471EB085.5080604@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471EB085.5080604@garzik.org>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Wakko Warner wrote:
> >Please CC me.
> 
> Please don't use
> 
> 	Mail-Followup-To: linux-kernel@vger.kernel.org
> 
> in your emails then :)

I'm not sending out that header.  Maybe I should with my address?

> >I've looked around and the only thing I can find was a git repository for
> >it.  I don't know anything about git.  I just want to get the driver so I
> >can use the sata drives I have on this controller.
> >
> >I'm currently using 2.6.22.
> 
> hum, it should be working in 2.6.22.  There were some minor fixes and 
> changes in 2.6.23 that you might want to try, but overall, we are 
> interested in your bug report.

Dmesg says:
[  335.120000] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[  335.120000] ACPI: PCI Interrupt 0000:07:02.0[A] -> GSI 30 (level, low) ->
IRQ 20
[  335.120000] aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter,
device 0000:07:02.0
[  335.120000] scsi12 : aic94xx
[  337.748000] aic94xx: Found sequencer Firmware version 1.1 (V17/10c6)
[  337.792000] aic94xx: device 0000:07:02.0: SAS addr 5003048000509c60, PCBA
SN ORG, 8 phys, 8 enabled phys, flash present, BIOS build 1822
[  337.836000] ERROR: Unidentified device type 5
[  337.836000] ERROR: Unidentified device type 5
[  337.836000] ERROR: Unidentified device type 5
[  337.836000] ERROR: Unidentified device type 5
[  337.836000] ERROR: Unidentified device type 5
[  337.836000] ERROR: Unidentified device type 5

I currently have 6 sata devices attached to ports 0-2 and 4-6.  The
controller's bios sees them properly.  libata is also loaded.

I'll give 2.6.23 a try tomorrow, I didn't realise it was available already.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
