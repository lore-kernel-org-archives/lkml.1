Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbYE1Nn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbYE1Nn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYE1Nnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:43:49 -0400
Received: from server.drzeus.cx ([85.8.24.28]:35882 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750909AbYE1Nns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:43:48 -0400
Date: Wed, 28 May 2008 15:42:43 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 not recognizing 2G MMC card?
Message-ID: <20080528154243.46011abf@mjolnir.drzeus.cx>
In-Reply-To: <20080521172104.GC2592@fieldses.org>
References: <20080521172104.GC2592@fieldses.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 13:21:04 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> Please forgive a somewhat naive question--I'm not sure how to go about
> debugging this kind of thing:
> 
> I have a Dell 1420n with card readers reported by lspci as:
> 
> 03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
> 03:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
> 
> I have a 512MB MicroSD card which seems to be recognized fine, but a 2GB
> MMC card is not.
> 

Do you have any other MMC cards that work? Ricoh doesn't something
silly when it comes to MMC cards that fouls things up.

> 
> Anything I should try?  Thanks in advance for any suggestions.
> 

If you have a newer controller, then the ricoh_mmc module won't be able
to do its magic. Try the following patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=882c49164d72c45f37d7fa1bb3de7c31cf1a5fab

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
