Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYA3Upp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYA3Upp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYA3Upg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:45:36 -0500
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:36016 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750923AbYA3Upf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:45:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BueQ8JKIKwwfdpUv3d/mXqx3/2aN4m5oo760xb53d7+L/Fvq2tzCr5JMdjUr5600kW/Z+UugKcowOP2kLxuWVGy0jmoMWBFs4VSCUCfW+KWvbx6hsuRFrnpf8dpIt0p9Tk3qkumqf7Z91hHOevawmrPedva6u26MS6jvZSflNC8=  ;
X-YMail-OSG: _D7OnAwVM1nvA4SCRk2Fob5MhE0OrePBvdbnZNH5TpFyhNe5s47X47gRTNQl6KfqNbbUNShOkw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Date: Wed, 30 Jan 2008 12:45:31 -0800
User-Agent: KMail/1.9.6
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com> <200801300252.50344.david-b@pacbell.net> <e9c3a7c20801301028l12af0f6bv90509ea08c319bc6@mail.gmail.com>
In-Reply-To: <e9c3a7c20801301028l12af0f6bv90509ea08c319bc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801301245.32286.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008, Dan Williams wrote:
> On Jan 30, 2008 3:52 AM, David Brownell <david-b@pacbell.net> wrote:
> > On Wednesday 30 January 2008, Haavard Skinnemoen wrote:
> > > Descriptor-based vs. register-based transfers sounds like something the
> > > DMA engine driver is free to decide on its own.
> >
> > Not entirely.  The current interface has "dma_async_tx_descriptor"
> > wired pretty thoroughly into the call structure -- hard to avoid.
> > (And where's the "dma_async_rx_descriptor", since that's only TX??
> > Asymmetry like that is usually not a healthy sign.)  The engine is
> > not free to avoid those descriptors ...
> >
> 
> For better or worse I picked async_tx to represent "asynchronous
> transfers/transforms", not "transmit". 

"dma_async_descriptor" would not be misleading.  :)
