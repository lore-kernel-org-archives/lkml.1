Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbYKNVc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbYKNVc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYKNVcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:32:47 -0500
Received: from server.drzeus.cx ([85.8.24.28]:52162 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755036AbYKNVcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:32:45 -0500
Date: Fri, 14 Nov 2008 22:32:42 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 3/7] SDHCI: Add set_ios hook
Message-ID: <20081114223242.394216fd@mjolnir.drzeus.cx>
In-Reply-To: <20081103201010.314538796@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
	<20081103201010.314538796@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008 20:09:47 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> Add a set_ios hook which is called when the SDHCI driver
> is called to change parameters such as clock or card
> width.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 

Hmm... this is very general and very much undefined. I think we need to
have some kind of formal API here or I might end up breaking S3C
support when I hack away at the driver.

Preferable, I'd like to see a more fine grained set of callbacks.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
