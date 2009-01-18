Return-Path: <linux-kernel-owner+w=401wt.eu-S934037AbZARPuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037AbZARPuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 10:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932246AbZARPuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 10:50:37 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58030 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759926AbZARPuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 10:50:37 -0500
Message-ID: <49734FC6.9070500@garzik.org>
Date: Sun, 18 Jan 2009 10:50:30 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Carsten Schlote <c.schlote@konzeptpark.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][ATA] Add ide-disk led-trigger to ATA subsystem
References: <1231600107.10065.4.camel@kplaws107lx> <20090118081140.GA1944@ucw.cz>
In-Reply-To: <20090118081140.GA1944@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2009-01-10 16:08:27, Carsten Schlote wrote:
>>  void ata_sff_exec_command(struct ata_port *ap, const struct
>> ata_taskfile *tf)
>>  {
>> +	ledtrig_ide_activity();
>> +
>>  	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
>>  
>>  	iowrite8(tf->command, ap->ioaddr.command_addr);
>>
> 
> Is there a more generic place so that we won't have to modify all the
> libata drivers?


One would think you could do this at the block layer...

	Jeff



