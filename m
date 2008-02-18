Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbYBRWOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbYBRWOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYBRWNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:13:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50912 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbYBRWNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:13:54 -0500
Date: Mon, 18 Feb 2008 22:13:24 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Message-ID: <20080218221324.GB23181@flint.arm.linux.org.uk>
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802182308.56789.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802182308.56789.mb@bu3sch.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 11:08:56PM +0100, Michael Buesch wrote:
> On Monday 18 February 2008 23:03:10 Gordon Farquharson wrote:
> > The b43 driver in 2.6.25-rc[12] fails to build for arm on an x86_64
> > box using a cross-compiler:
> > 
> > FATAL: drivers/net/wireless/b43/b43: sizeof(struct ssb_device_id)=6 is
> > not a modulo of the size of section __mod_ssb_device_table=64.
> > Fix definition of struct ssb_device_id in mod_devicetable.h
> 
> Why does ARM have this special requirement and what is it about?

Because ARM is a 32 bit architecture.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
