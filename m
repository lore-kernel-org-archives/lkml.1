Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715Ab0ARRxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0ARRxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900Ab0ARRxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:53:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37504 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754435Ab0ARRxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:53:10 -0500
Date: Mon, 18 Jan 2010 17:55:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/64] pata_efar: always program master_data before
 slave_data
Message-ID: <20100118175556.755ae155@lxorguk.ukuu.org.uk>
In-Reply-To: <20100118171555.14623.3131.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171555.14623.3131.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 18:15:55 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_efar: always program master_data before slave_data
> 
> We may need to set SITRE before programming slave_data.

You don't - but making them all the same is worth doing anyway for
readability and future possibly merging into helpers


