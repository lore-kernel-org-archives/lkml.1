Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYGVTdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYGVTdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbYGVTdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:33:23 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:33114 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbYGVTdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:33:21 -0400
Message-ID: <48863680.4080203@keyaccess.nl>
Date: Tue, 22 Jul 2008 21:35:28 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
References: <200807042153.56644.linux@rainbow-software.org> <200807221959.53669.linux@rainbow-software.org> <20080722191022.0417f45c@lxorguk.ukuu.org.uk> <200807222116.19077.linux@rainbow-software.org>
In-Reply-To: <200807222116.19077.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-07-08 21:16, Ondrej Zary wrote:

> On Tuesday 22 July 2008 20:10:22 Alan Cox wrote:

>> On the bright side that also allows us to implement a pata_mfm/rll 
>> driver at last.
> 
> I used to have an old drive that was something like that - 5.25"
> Seagate 40MB drive. I sold it including the controller a couple of
> years ago (it was still working) so no testing fun for me.

Looking at a Western Digital "FileCard 30" consisting of a Seagate 
ST-125 and WDQC16 8-bit ISA controller. MFM I believe.

I put a sticker on it with: "io=0x320, irq=5, dma=3 615/4/26 (or 614)"

The thing has its own BIOS and if If I'm not mistaken it could only live 
in an AT+ with all other drives in the BIOS turned of. This might mean 
I'd be capable of testing it from a boot-floppy only but if you 
desperately want a tester, I'll try to volunteer ;-)

I remember using DOS "debug" to jump into its BIOS low-level format 
routine so I did get it doing something...

Rene.
