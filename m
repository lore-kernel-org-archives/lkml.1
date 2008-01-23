Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYAWOGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYAWOGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYAWOG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:06:29 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:64980 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751375AbYAWOG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:06:28 -0500
Date: Wed, 23 Jan 2008 15:05:11 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: Andrew Victor <linux@maxim.org.za>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>
Subject: Re: [PATCH 6/6] atmel_serial: Add DMA support
Message-ID: <20080123150511.3785986c@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801231452.55388.marc.pignat@hevs.ch>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com>
	<200801231418.38997.marc.pignat@hevs.ch>
	<20080123143503.764bc8cf@dhcp-252-066.norway.atmel.com>
	<200801231452.55388.marc.pignat@hevs.ch>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008 14:52:55 +0100
Marc Pignat <marc.pignat@hevs.ch> wrote:

> On Wednesday 23 January 2008, Haavard Skinnemoen wrote:
> > On Wed, 23 Jan 2008 14:18:38 +0100
> ...
> > GFP_DMA doesn't have anything to do with alignment, AFAIK.
> I don't even know if it does something for at91 or avr32, but there is a flag
> for dma memory, so we should use it.

No, I think GFP_DMA is for legacy ISA DMA and other DMA controllers
with addressing limitations. The PDC is capable of accessing the full
32-bit physical address space on both AT91 and AVR32, so no special DMA
flags are needed.

Haavard
