Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXDWPJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXDWPJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 11:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbXDWPJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 11:09:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42679 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752694AbXDWPJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 11:09:39 -0400
Date: Mon, 23 Apr 2007 16:13:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Nvidia AGP: Use refcount aware PCI interfaces
Message-ID: <20070423161303.1ab45692@the-village.bc.nu>
In-Reply-To: <20070423142114.GA19674@redhat.com>
References: <20070423145027.47f1ba38@the-village.bc.nu>
	<20070423142114.GA19674@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 10:21:14 -0400
Dave Jones <davej@redhat.com> wrote:

> On Mon, Apr 23, 2007 at 02:50:27PM +0100, Alan Cox wrote:
>  > Signed-off-by: Alan Cox <alan@redhat.com>
> 
> This is lacking a changelog.  What's the purpose of changing this?
> Is pci_find_slot() obsolete and going away? (If so, it should be

That is the intention because most users of pci_find_slot are unsafe.

Alan
