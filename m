Return-Path: <linux-kernel-owner+w=401wt.eu-S933773AbYBBUv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbYBBUv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933942AbYBBUvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:51:46 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38920 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933685AbYBBUvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:45 -0500
Date: Sat, 2 Feb 2008 21:51:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: spi-devel-general@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SPI related Kconfig warning
Message-ID: <20080202205149.GC26635@uranus.ravnborg.org>
References: <D5CED6F1-A708-4866-BA3D-75F3CCBA43F6@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D5CED6F1-A708-4866-BA3D-75F3CCBA43F6@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 10:41:33PM -0600, Kumar Gala wrote:
> Was wondering if anyone was looking at the cause of this warning in  
> top of linus's tree (8af03e782cae1e0a0f530ddd22301cdd12cf9dc0)
> 
> drivers/spi/Kconfig:156:warning: 'select' used by config symbol  
> 'SPI_PXA2XX' refers to undefined symbol 'PXA_SSP'
> 
> I was doing a build of a ppc kernel.

I have now killed that warning. from kconfig. It has
proved rather useless but annoying.

	Sam
