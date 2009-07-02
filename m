Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZGBL7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZGBL7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 07:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZGBL7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 07:59:22 -0400
Received: from relay.atmel.no ([80.232.32.139]:57700 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZGBL7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 07:59:22 -0400
Date: Thu, 2 Jul 2009 13:58:49 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: pierre@ossman.eu, s.hauer@pengutronix.de, kernel <kernel@avr32linux.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MMC Core: Drop initialization frequency floor to 50kHz
Message-ID: <20090702135849.21370282@hskinnemoen-d830>
In-Reply-To: <1246492196.2980.17.camel@linux-51e8.site>
References: <1246492196.2980.17.camel@linux-51e8.site>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette wrote:
> Was recently merged.  This is too fast for at least one setup
> permutation - the one on my desk which through trial and error won't
> initialise at anything above ~350kHz (older Sandisk 256MB SD on
> atmel-mci).

What kind of board is this? It sounds a bit like the CMD or DATA0
pull-up is too weak...

Haavard
