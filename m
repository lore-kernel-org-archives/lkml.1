Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbYBRWZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbYBRWZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYBRWZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:25:11 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:51420 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbYBRWZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:25:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Date: Mon, 18 Feb 2008 23:24:44 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802182308.56789.mb@bu3sch.de> <20080218221324.GB23181@flint.arm.linux.org.uk>
In-Reply-To: <20080218221324.GB23181@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802182324.45267.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008 23:13:24 Russell King wrote:
> On Mon, Feb 18, 2008 at 11:08:56PM +0100, Michael Buesch wrote:
> > On Monday 18 February 2008 23:03:10 Gordon Farquharson wrote:
> > > The b43 driver in 2.6.25-rc[12] fails to build for arm on an x86_64
> > > box using a cross-compiler:
> > > 
> > > FATAL: drivers/net/wireless/b43/b43: sizeof(struct ssb_device_id)=6 is
> > > not a modulo of the size of section __mod_ssb_device_table=64.
> > > Fix definition of struct ssb_device_id in mod_devicetable.h
> > 
> > Why does ARM have this special requirement and what is it about?
> 
> Because ARM is a 32 bit architecture.

Ehm, I didn't see this warning on any other architecture nor did we
have _any_ problem with it on any other architecture.
This code runs fine on x86_32, x86_64, powerpc and mips, at least.

-- 
Greetings Michael.
