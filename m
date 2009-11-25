Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbZKYRyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbZKYRyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759368AbZKYRyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:54:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54954 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757628AbZKYRyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:54:03 -0500
Date: Wed, 25 Nov 2009 17:56:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 85/86] libata: add ->init_host method
Message-ID: <20091125175608.5e1b5442@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125171240.5446.31841.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125171240.5446.31841.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:12:40 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] libata: add ->init_host method
> 
> Add ->init_host method for re-initialization of the controller
> in ata_pci_device_resume().

Would be much cleaner if the init_host method was in the ops stuff
somewhere rather than assigned all over the place separately - because
then folks forget and its not part of the inheriting.

Definitely a good thing though
