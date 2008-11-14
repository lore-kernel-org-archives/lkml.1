Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYKNV3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYKNV3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYKNV3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:29:10 -0500
Received: from server.drzeus.cx ([85.8.24.28]:45738 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751204AbYKNV3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:29:09 -0500
Date: Fri, 14 Nov 2008 22:29:06 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 1/7] SDHCI: Add timeout hooks
Message-ID: <20081114222906.5b5f0450@mjolnir.drzeus.cx>
In-Reply-To: <20081103201010.053060157@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
	<20081103201010.053060157@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008 20:09:45 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> Some controllers do not provide clock information in their
> capabilities (in the Samsung case, it is because there are
> multiple clock sources available to the controller). Add hooks
> to allow the system to supply clock information.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 

Could we at least initally try to strictly adhere to the SDHCI spec and
only use the callback if the controller reports 0 for the freqs?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
