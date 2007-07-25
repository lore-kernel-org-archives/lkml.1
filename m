Return-Path: <linux-kernel-owner+w=401wt.eu-S1764680AbXGYHzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764680AbXGYHzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbXGYHzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:55:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:54686 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbXGYHzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:55:22 -0400
Subject: Re: modpost warning question
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: sam@ravnborg.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707250210520.14366@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0707250210520.14366@blarg.am.freescale.net>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 17:55:03 +1000
Message-Id: <1185350103.5439.314.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 02:14 -0500, Kumar Gala wrote:
> I'm seeing the following warning:
> 
> WARNING: vmlinux.o(.init.text+0x1acdc): Section mismatch: reference to
> .exit.text:gfar_mdio_exit (between 'gfar_init' and 'gfar_mdio_init')
> 
> I don't understand why its not ok to access .exit.text from .init.text
> 
> The following addresses the issue, however I don't particularly like it:

Because exit.text is removed when compiling built-in

Ben.


