Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZFXWzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZFXWzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZFXWz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:55:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45025 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752138AbZFXWz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:55:27 -0400
Date: Wed, 24 Jun 2009 23:55:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, kevin.huang@rdc.com.tw, greg@kroah.com,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] pata_rdc: driver for RDC ATA devices
Message-ID: <20090624235548.681b8992@lxorguk.ukuu.org.uk>
In-Reply-To: <4A42800D.6020202@garzik.org>
References: <20090624172930.24354.80799.stgit@t61.ukuu.org.uk>
	<4A42800D.6020202@garzik.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Seems fine and fairly straightforward to me.  My lone comment -- go 
> through and replace magic numbers with named constants, for e.g. the PCI 
> config registers that program timings...

Its based on your ata_piix driver. Feel free to update that and I'll pull
names and things across to match.
