Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZKDQed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZKDQed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbZKDQec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:34:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38428 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757015AbZKDQec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:34:32 -0500
Date: Wed, 4 Nov 2009 16:36:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH -2nd repost 1/1] ATA: pata_via, fix double put on isa
 bridge
Message-ID: <20091104163611.4e71f01d@lxorguk.ukuu.org.uk>
In-Reply-To: <1257351063-5616-1-git-send-email-jirislaby@gmail.com>
References: <1257351063-5616-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Nov 2009 17:11:03 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> In via_init_one, when via_isa_bridges iterator reaches
> PCI_DEVICE_ID_VIA_ANON and last but one via_isa_bridges bridge is
> found but rev doesn't match, pci_dev_put(isa) is called twice.
> 
> Do pci_dev_put only once.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jeff Garzik <jgarzik@pobox.com>

Acked-by: Alan Cox <alan@linux.intel.com>

Definitely a far saner way to do it.
