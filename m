Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbYKYQeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbYKYQeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYKYQeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:34:04 -0500
Received: from rtr.ca ([76.10.145.34]:37730 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYKYQeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:34:03 -0500
Message-ID: <492C2936.9080608@rtr.ca>
Date: Tue, 25 Nov 2008 11:35:02 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>	<491E4092.5030804@shaw.ca>	<20081115103424.34f01370@lxorguk.ukuu.org.uk>	<491FBA29.3000803@kernel.org>	<20081116112511.3913123a@lxorguk.ukuu.org.uk>	<492AF06A.8020004@rtr.ca> <20081124183204.2d3734e3@lxorguk.ukuu.org.uk>
In-Reply-To: <20081124183204.2d3734e3@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Well ata_piix for starters.  Verified here by me.
> 
> Some piix are fine (mine are) so maybe its a device property in part.
> Certainly it is needed for some combinations including current stuff like
> jmicron PATA ports.
..

Agreed -- here it was a notebook (Dell Inspiron 9300) with ata_piix
and a PATA drive.  So the mainboard in the notebook had an onboard bridge
chip to adapt the PATA drive to the internal SATA port.

The subsequent model notebook (Dell Inspiron 9400) has very similar innards,
except it now uses SATA drives, so no bridge chip.

The former needs DRQ draining, the latter does not.
So, yeah, it's probably the bridge chip in this case.

Cheers
