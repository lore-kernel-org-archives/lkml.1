Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXLVU2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXLVU2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXLVU2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:28:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbXLVU2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:28:42 -0500
Date: Sat, 22 Dec 2007 12:28:07 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] opt the sky2 driver into using extended config space
Message-ID: <20071222122807.6237995f@shemminger-laptop>
In-Reply-To: <20071222043559.105e0a6c@laptopd505.fenrus.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
	<20071222043559.105e0a6c@laptopd505.fenrus.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 04:35:59 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: opt the sky2 driver into using extended config space
> 
> So far, the sky2 driver is the only one I've identified (with a quick grep)
> that actually would be using extended configuration space; the patch below
> adds the enablement of this to the driver.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> CC: shemminger@linux-foundation.org

Current driver uses the drivers memory map access to PCI config space
to avoid all the extra config space access issues. So this patch is not needed.
