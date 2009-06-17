Return-Path: <linux-kernel-owner+w=401wt.eu-S1764803AbZFQKJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764803AbZFQKJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbZFQKI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:08:56 -0400
Received: from relay.atmel.no ([80.232.32.139]:56896 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZFQKI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:08:56 -0400
Date: Wed, 17 Jun 2009 12:08:49 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Rob Emanuele <rob@emanuele.us>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] atmel-mci: Unified Atmel MCI drivers (AVR32 & AT91)
Message-ID: <20090617120849.4b11386a@hskinnemoen-d830>
In-Reply-To: <4A38BDB8.5030804@atmel.com>
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>
	<4A38BDB8.5030804@atmel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> > -#define ATMCI_DATA_ERROR_FLAGS	(MCI_DCRCE | MCI_DTOE | MCI_OVRE | MCI_UNRE)
> > +#define ATMCI_DATA_ERROR_FLAGS	(MCI_RINDE | MCI_RDIRE | MCI_RCRCE  \
> > +				 | MCI_RENDE | MCI_RTOE | MCI_DCRCE \
> > +				 | MCI_DTOE | MCI_OVRE | MCI_UNRE)  
> 
> Haavard, is it ok to add those flags on an AVR32 platform for now ?

It probably doesn't hurt on AVR32. But I'm not a great fan since it
seems like the wrong thing to do, and it may simply mask the real
problem.

Haavard
