Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbXIMJTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbXIMJTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbXIMJSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:18:52 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:45593 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbXIMJSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:18:51 -0400
Date: Thu, 13 Sep 2007 05:03:18 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Micah Gruber <micah.gruber@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [CORRECTION][PATCH] Fix a potential NULL pointer dereference in uli526x_interrupt() in drivers/net/tulip/uli526x.c
Message-ID: <20070913090318.GA6196@fattire.cabal.ca>
References: <46DD13CE.6010905@gmail.com> <20070913020346.979647c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913020346.979647c1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 02:03:46AM -0700, Andrew Morton wrote:
> I suspect the fix we want is:
> 

ack. The trend seems to be to avoid this redundant check in the
interrupt handler.
