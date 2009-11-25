Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbZKYRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbZKYRqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbZKYRqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:46:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40291 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932456AbZKYRqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:46:39 -0500
Date: Wed, 25 Nov 2009 17:48:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 69/86] pata_scc: add 32-bit PIO support
Message-ID: <20091125174844.7e7b3106@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125171039.5446.68680.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125171039.5446.68680.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:10:39 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_scc: add 32-bit PIO support
> 
> There shouldn't be any problems with it as IDE scc_pata host driver
> has been allowing 32-bit PIO operations for years.

NAK; Read the code - it uses its own private data_xfer handler anyway
