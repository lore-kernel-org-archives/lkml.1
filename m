Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZFVX6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZFVX6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZFVX6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:58:14 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:53048 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbZFVX6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:58:13 -0400
From: Frans Pop <elendil@planet.nl>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] cs5520: add missing IRQ setup for the second port
Date: Tue, 23 Jun 2009 01:58:11 +0200
User-Agent: KMail/1.9.9
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906221348.02632.bzolnier@gmail.com> <200906221348.02632.bzolnier@gmail.com> <20090622.163136.246300819.davem@davemloft.net>
In-reply-To: <20090622.163136.246300819.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230158.12805.elendil@planet.nl>
X-OriginalArrivalTime: 22 Jun 2009 23:58:15.0445 (UTC) FILETIME=[4ECC2C50:01C9F395]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> ide_pci_setup_ports() would loop over the available ports, one
> by one, recording IRQ numbers increasingly from the one passed
> in as "pciirq".

I looked at the commit and at the code and called functions several times 
(just out of curiosity), but have been completely unable to find where 
that increase of pciirq actually happened.
AFAICT ide_pci_setup_ports() just passed it on to ide_hw_configure() and 
all that did was 'hw->irq = irq', so AFAICT in the old case both ports 
would get the *same* IRQ, and not consecutive ones.

Am I missing something here?
