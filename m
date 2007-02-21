Return-Path: <linux-kernel-owner+w=401wt.eu-S1751236AbXBUMJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbXBUMJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbXBUMJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:09:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48753 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751233AbXBUMJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:09:16 -0500
Date: Wed, 21 Feb 2007 13:12:59 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Suleiman Souhlal <ssouhlal@FreeBSD.org>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Don't change transfer speed while requests are in
 flight
Message-ID: <20070221131259.3817762d@lxorguk.ukuu.org.uk>
In-Reply-To: <20070221012112.GB1777@freefall.freebsd.org>
References: <20070221012112.GB1777@freefall.freebsd.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	 * If we are in an interrupt, it should be safe to issue
> +	 * SETFEATURES manually, since there shouldn't be any requests in
> +	 * flight.

There may be error recovery going on from a timeout on another processor.
I don't see how your code protects against that (and the old code is
broken too)

