Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZFXJUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZFXJUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZFXJUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:20:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46095 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750957AbZFXJUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:20:37 -0400
Date: Wed, 24 Jun 2009 10:22:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: bzolnier@gmail.com, elendil@planet.nl, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5520: add missing IRQ setup for the second port
Message-ID: <20090624102200.7debd041@lxorguk.ukuu.org.uk>
In-Reply-To: <20090623.164429.179899088.davem@davemloft.net>
References: <20090623094206.4d1f1b5b@lxorguk.ukuu.org.uk>
	<200906231159.01295.bzolnier@gmail.com>
	<20090623163324.715421f5@lxorguk.ukuu.org.uk>
	<20090623.164429.179899088.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What should we do?  I guess "do nothing and wait until we see a bug
> report from an actual user" is a valid response...


I doubt you ever will.

The docs don't say so I'd assume its hard coded 14/15 as if it was ISA
(its not an IDE storage class device so doesn't have the PCI config bits
to switch between legacy and native modes).

Alan
