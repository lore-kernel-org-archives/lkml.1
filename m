Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZCaTpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZCaTpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZCaTor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:44:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60675 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751536AbZCaTor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:44:47 -0400
Date: Tue, 31 Mar 2009 20:16:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 13/17] x86: allow the irq->vector translation to be
 determined outside of ioapic
Message-ID: <20090331201625.60f1ea81@the-village.bc.nu>
In-Reply-To: <20090331184355.28333.72382.stgit@dev.haskins.net>
References: <20090331184057.28333.77287.stgit@dev.haskins.net>
	<20090331184355.28333.72382.stgit@dev.haskins.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 14:43:55 -0400
Gregory Haskins <ghaskins@novell.com> wrote:

> The ioapic code currently privately manages the mapping between irq
> and vector.  This results in some layering violations as the support
> for certain MSI operations need this info.  As a result, the MSI
> code itself was moved to the ioapic module.  This is not really
> optimal.

This appears to have been muddled in with the vnet patches ?
