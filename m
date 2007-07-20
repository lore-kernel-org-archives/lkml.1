Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbXGTEDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbXGTEDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbXGTEDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:03:11 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:35065 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbXGTEDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:03:10 -0400
Date: Fri, 20 Jul 2007 13:02:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pata_platform: Fix NULL pointer dereference
Message-ID: <20070720040251.GA23758@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20070720035058.25300.28389.sendpatchset@clockwork.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720035058.25300.28389.sendpatchset@clockwork.opensource.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 12:50:58PM +0900, Magnus Damm wrote:
> pata_platform: Fix NULL pointer dereference
> 
> pata_platform currently dereferences a NULL pointer in pata_platform_probe()
> if pdev->dev.platform_data is set to NULL. This breakage was most likely
> introduced by commit 5f45bc50976ee1f408f7171af155aec646655a37.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

Without this, most of the sh and ppc pata_platform users won't boot.

Acked-by: Paul Mundt <lethal@linux-sh.org>
