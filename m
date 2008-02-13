Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbYBMIDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbYBMIDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYBMIDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:03:15 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:64794 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750943AbYBMIDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:03:14 -0500
Date: Wed, 13 Feb 2008 09:03:10 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC v3 4/7] dmaengine: Add slave DMA interface
Message-ID: <20080213090310.0c905397@dhcp-252-066.norway.atmel.com>
In-Reply-To: <e9c3a7c20802122321g7241c383ofd9a3bf6f419c7c7@mail.gmail.com>
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20802122321g7241c383ofd9a3bf6f419c7c7@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 00:21:41 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> On Feb 12, 2008 9:43 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> [..]
> > +enum dma_slave_direction {
> > +       DMA_SLAVE_TO_MEMORY,
> > +       DMA_SLAVE_FROM_MEMORY,
> > +};
> 
> Just reuse enum dma_data_direction from the dma-mapping api.

Hmm...ok. That will add two "directions" that are a bit useless in this
context (DMA_BIDIRECTIONAL and DMA_NONE.) But I guess it's still worth
it since we can pass the direction on unchanged when syncing the
buffers.

Haavard
