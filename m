Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbXKXPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbXKXPgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 10:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbXKXPgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 10:36:03 -0500
Received: from relais.videotron.ca ([24.201.245.36]:47532 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXKXPgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 10:36:01 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 24 Nov 2007 10:35:44 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Andre Haupt <andre@bitwigglers.org>, lkml <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: Re: [PATCH] sdio_uart: fix sign of paramter status in
 sdio_uart_receive_chars()
In-reply-to: <20071124153650.27a572a6@poseidon.drzeus.cx>
Message-id: <alpine.LFD.0.99999.0711241029010.9605@xanadu.home>
References: <11956448251191-git-send-email-andre@bitwigglers.org>
 <20071124153650.27a572a6@poseidon.drzeus.cx>
User-Agent: Alpine 0.99999 (LFD 814 2007-11-14)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007, Pierre Ossman wrote:

> On Wed, 21 Nov 2007 12:33:45 +0100
> Andre Haupt <andre@bitwigglers.org> wrote:
> 
> > I think, the status paramter should be unsigned. Is this correct?
> > This also fixes a sparse warning about different signedness.
> > Only compile tested, because i do not have the hardware.
> > 
> > From: Andre Haupt <andre@bitwigglers.org>
> > Signed-off-by: Andre Haupt <andre@bitwigglers.org>
> 
> Nicolas, does this seem correct to you? I'm not familiar with the 
> serial stuff.

Yes, that should be fine.

Acked-by: Nicolas Pitre <nico@cam.org>


Nicolas
