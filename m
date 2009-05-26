Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbZEZGOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbZEZGOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 02:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZEZGOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 02:14:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:59024 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZEZGOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 02:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Mo7Ptim9lJ4a6hB7UWEby+WvT7LVwuiAgajkc1iUszqUGeLGlXYupWAFfBhNIDNCTK
         QIrpJjywpM/uu035fMtCNEUFyO148xdf/lO834E1kNjssX/SRyA2/yAROQbINODeSUV3
         901Dzjj11YPei8OqYSQ43k7z/9JhsPeRGpJ0w=
Subject: Re: [PATCH v2] MFD: PCAP core driver.
From: Daniel Ribeiro <drwyrm@gmail.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Harald Welte <laforge@gnumonks.org>,
       David Brownell <david-b@pacbell.net>,
       openezx-devel <openezx-devel@lists.openezx.org>
In-Reply-To: <1243314635.10927.30.camel@brutus>
References: <1242740566.6142.54.camel@brutus>
	 <1242928320.22873.18.camel@brutus>
	 <74d0deb30905251255o2d0fb0edr4b2f52aa6a696d7c@mail.gmail.com>
	 <1243314635.10927.30.camel@brutus>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 May 2009 03:14:31 -0300
Message-Id: <1243318471.10927.53.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Ter, 2009-05-26 às 02:10 -0300, Daniel Ribeiro escreveu:
> > > +       set_irq_type(pdata->irq, IRQ_TYPE_EDGE_RISING);
> > > +       set_irq_chained_handler(pdata->irq, pcap_irq_handler);
> > > +       set_irq_wake(pdata->irq, 1);
> > 
> > Looking at the other MFD drivers that register a chained handler,
> > providing this IRQ via a resource seems to be the default.
> 
> Ok, will do.

Oops, I can't do this, sorry. PCAP is not a platform_driver, its a
spi_driver. I will set this on spi_device->irq instead of platform_data.

-- 
Daniel Ribeiro

