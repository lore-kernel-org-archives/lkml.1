Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbYHQR7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbYHQR7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYHQR7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:59:47 -0400
Received: from server.drzeus.cx ([85.8.24.28]:53340 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750858AbYHQR7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:59:46 -0400
Date: Sun, 17 Aug 2008 19:59:40 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: s3cmci: fix sparse errors from non-exported functions
Message-ID: <20080817195940.3a422a04@mjolnir.drzeus.cx>
In-Reply-To: <20080808095540.450997837@fluff.org.uk>
References: <20080808095540.450997837@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Aug 2008 10:55:41 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> Fix the following sparse errors by making the functions
> static and fixing the check for host->base.
> 
> 598:6: warning: symbol 's3cmci_dma_done_callback' was not declared. Should it be static?
> 744:6: warning: symbol 's3cmci_dma_setup' was not declared. Should it be static?
> 1209:20: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 

Applied.
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
