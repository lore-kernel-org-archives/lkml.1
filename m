Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbXLEChw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbXLEChw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 21:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXLECho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 21:37:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:50409 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbXLEChn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 21:37:43 -0500
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b
	resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071204060911.EA82BDDE19@ozlabs.org>
References: <20071204060911.EA82BDDE19@ozlabs.org>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 13:37:03 +1100
Message-Id: <1196822223.13230.344.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-04 at 17:08 +1100, Benjamin Herrenschmidt wrote:
> The current pci_assign_unassigned_resources() code doesn't work properly
> on 32 bits platforms with 64 bits resources. The main reason is the use
> of unsigned long in various places instead of resource_size_t.
> 
> This fixes it, along with some tricks to avoid casting to 64 bits on
> platforms that don't need it in every printk around.
> 
> This is a pre-requisite for making powerpc use the generic code instead of
> its own half-useful implementation.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Drop it for now, stupid warnings without 64 bits resources... I'll fix
that.

Ben.


