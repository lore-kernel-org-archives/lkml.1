Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbXFYTjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbXFYTjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXFYTjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:39:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59164 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbXFYTjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:39:15 -0400
Date: Mon, 25 Jun 2007 20:39:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linuxppc-dev@ozlabs.org, Russell King <rmk+lkml@arm.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] pcmcia: CompactFlash driver for PA Semi Electra boards
Message-ID: <20070625193909.GA26021@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
	linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
	Russell King <rmk+lkml@arm.linux.org.uk>
References: <20070625010311.GA31355@lixom.net> <20070625171221.GA6684@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625171221.GA6684@lixom.net>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 12:12:21PM -0500, Olof Johansson wrote:
> Driver for the CompactFlash slot on the PA Semi Electra eval board. It's
> a simple device sitting on localbus, with interrupts and detect/voltage
> control over GPIO.
> 
> The driver is implemented as an of_platform driver, and adds localbus
> as a bus being probed by the of_platform framework.

Looks good to me. The only odd thing is the inconsistant use of
#ifdef CONFIG_PCMCIA in setup.c.

