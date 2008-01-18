Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbYARK4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbYARK4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYARK4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:56:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:37487 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755614AbYARK4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:56:09 -0500
X-Authenticated: #429267
X-Provags-ID: V01U2FsdGVkX18eoPdm3SQetLAcyWSVhHIQ+izv25NQ8oDQ/zLgDK
	gVdLtYp/XmcSRo
Subject: Re: Spammed logs again rt2500pci 2.6.24-rc8
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, IvDoorn@gmail.com
In-Reply-To: <20080117225744.29aa214c@Varda>
References: <20080117225744.29aa214c@Varda>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 18 Jan 2008 11:56:05 +0100
Message-Id: <1200653765.7492.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we currently think this is due to a race condition in the packet queue
code. Ivo is currently reworking the packet queues, which I hope will
resolve this situation.

Mattias

On Thu, 2008-01-17 at 22:57 +0100, Alejandro Riveira Fernández wrote:
> Running
> 
> Linux Varda 2.6.24-rc8 #1 SMP PREEMPT Wed Jan 16 15:09:43 CET 2008 x86_64 GNU/Linux
> 
> my logs are spmmed with:
> 
> 
> [20126.343240] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20126.343242] Please file bug report to http://rt2x00.serialmonkey.com.
> [20126.848277] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20126.848280] Please file bug report to http://rt2x00.serialmonkey.com.
> [20126.851693] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20126.851696] Please file bug report to http://rt2x00.serialmonkey.com.
> [20126.851854] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20126.851856] Please file bug report to http://rt2x00.serialmonkey.com.
> [20126.852082] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20126.852084] Please file bug report to http://rt2x00.serialmonkey.com.
> [20126.852224] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20126.852226] Please file bug report to http://rt2x00.serialmonkey.com.
> [20127.349691] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20127.349694] Please file bug report to http://rt2x00.serialmonkey.com.
> [20127.352425] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20127.352428] Please file bug report to http://rt2x00.serialmonkey.com.
> [20127.853345] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20127.853348] Please file bug report to http://rt2x00.serialmonkey.com.
> [20127.853699] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20127.853701] Please file bug report to http://rt2x00.serialmonkey.com.
> [20128.858569] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20128.858572] Please file bug report to http://rt2x00.serialmonkey.com.
> [20131.875550] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20131.875554] Please file bug report to http://rt2x00.serialmonkey.com.
> [20154.693853] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20154.693856] Please file bug report to http://rt2x00.serialmonkey.com.
> [20185.527974] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20185.527977] Please file bug report to http://rt2x00.serialmonkey.com.
> [20189.812334] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20189.812337] Please file bug report to http://rt2x00.serialmonkey.com.
> [20189.812374] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20189.812376] Please file bug report to http://rt2x00.serialmonkey.com.
> [20189.812507] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20189.812509] Please file bug report to http://rt2x00.serialmonkey.com.
> [20189.813100] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20189.813102] Please file bug report to http://rt2x00.serialmonkey.com.
> [20189.813474] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20189.813476] Please file bug report to http://rt2x00.serialmonkey.com.
> [20189.813909] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20189.813911] Please file bug report to http://rt2x00.serialmonkey.com.
> [20212.242858] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20212.242861] Please file bug report to http://rt2x00.serialmonkey.com.
> [20212.243587] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> [20212.243589] Please file bug report to http://rt2x00.serialmonkey.com.
> 
> 
> As the last time the thing is triggered with a p2p app making a lot of connections (this time not bt but mldonkey)
> Back to top 	
> View user's profile Send private message 	
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

