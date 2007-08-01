Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbXHAUyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbXHAUyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXHAUx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:53:59 -0400
Received: from dsl081-058-254.sfo1.dsl.speakeasy.net ([64.81.58.254]:37677
	"EHLO gutschke.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbXHAUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:53:58 -0400
Message-ID: <46B0F2DF.90608@gutschke.com>
Date: Wed, 01 Aug 2007 13:53:51 -0700
From: Markus Gutschke <markus@gutschke.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Marvell 7042 (sata_mv) fails to initialize drive
References: <46AEAAB1.801@gutschke.com> <6bffcb0e0708011213q1c8908e2p1c87967745b977b5@mail.gmail.com>
In-Reply-To: <6bffcb0e0708011213q1c8908e2p1c87967745b977b5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have done some more testing, and it now looks as if this was actually 
a hardware fault. Reseating the PCI-E card made the problem go away 
(knock on wood). I am a little puzzled that it is possible for the card 
to show up on the PCI bus, and for the driver to be able to detect 
whether a disk is connected, but then for it to fail to communicate with 
the disk. But oh well, I guess if just some of the PCI-E signals aren't 
connected, strange error modes are to be expected.

Sorry for the false alarm. And just for the record, if any you need any 
more testing done with 7042 controllers, feel free to ask me for help -- 
I think I read somewhere that Jeff was looking for testers that have 
access to this hardware.


Markus
