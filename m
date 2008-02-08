Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbYBHCUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbYBHCUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYBHCUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:20:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60525
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbYBHCUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:20:09 -0500
Date: Thu, 07 Feb 2008 18:20:40 -0800 (PST)
Message-Id: <20080207.182040.196977279.davem@davemloft.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       isdn4linux@listserv.isdn4linux.de, kkeil@suse.de, jgarzik@pobox.com
Subject: Re: [PATCH] isdn: fix section mismatch warning in enpci_card_msg
From: David Miller <davem@davemloft.net>
In-Reply-To: <1201873364-13475-3-git-send-email-sam@ravnborg.org>
References: <20080201133838.GA13349@uranus.ravnborg.org>
	<1201873364-13475-3-git-send-email-sam@ravnborg.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri,  1 Feb 2008 14:42:42 +0100

> Fix following warnings:
> WARNING: drivers/isdn/hisax/built-in.o(.text+0x3cf50): Section mismatch in reference from the function enpci_card_msg() to the function .devinit.text:Amd7930_init()
> WARNING: drivers/isdn/hisax/built-in.o(.text+0x3cf85): Section mismatch in reference from the function enpci_card_msg() to the function .devinit.text:Amd7930_init()
> 
> enpci_card_msg() can be called outside __devinit context
> referenced function should not be annotated __devinit.
> 
> Remove annotation of Amd7930_init to fix this.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Applied, thanks.
