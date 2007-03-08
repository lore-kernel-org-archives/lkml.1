Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXCHO6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXCHO6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXCHO6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:58:09 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55264 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752060AbXCHO6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:58:08 -0500
Date: Thu, 8 Mar 2007 16:01:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: libata: Fix host->simplex_claimed != ap typo
Message-ID: <20070308160135.78bdef53@lxorguk.ukuu.org.uk>
In-Reply-To: <87lki7zuoz.fsf@duaron.myhome.or.jp>
References: <87lki7zuoz.fsf@duaron.myhome.or.jp>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2007 23:17:00 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Hi,
> 
> the following patch is needed to boot my laptop using pata_ali.ko, at least.
> Please apply.

NAK - correct fix is to check != && != NULL. The correct fix was posted
to the list earlier by Vojtech.

Alan
