Return-Path: <linux-kernel-owner+w=401wt.eu-S1761053AbZFWPd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053AbZFWPd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760866AbZFWPcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:32:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56842 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760792AbZFWPcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:32:03 -0400
Date: Tue, 23 Jun 2009 16:33:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, David Miller <davem@davemloft.net>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5520: add missing IRQ setup for the second port
Message-ID: <20090623163324.715421f5@lxorguk.ukuu.org.uk>
In-Reply-To: <200906231159.01295.bzolnier@gmail.com>
References: <200906221348.02632.bzolnier@gmail.com>
	<200906230158.12805.elendil@planet.nl>
	<20090623094206.4d1f1b5b@lxorguk.ukuu.org.uk>
	<200906231159.01295.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The cs5520 isn't a standard IDE controller in the first place and doesn't
> > have two channels anyway. It's special as it uses non standard bar
> 
> Please note that both cs5520.c / pata_cs5520.c assume that the controller
> has two ports (please verify whether they need some fixing, thanks)..

It can it turns out have two if the relevant external logic is present.

Alan
