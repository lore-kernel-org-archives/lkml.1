Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbYFRLsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbYFRLsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYFRLsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:48:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYFRLsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:48:02 -0400
Subject: Re: [PATCH 0/7] mmc: at91_mci: rework to allow better transfer
From: David Woodhouse <dwmw2@infradead.org>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Erik Mouw <mouw@nl.linux.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Pierre Ossman <drzeus@drzeus.cx>,
       Eric BENARD <ebenard@free.fr>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20080618114057.GE2226@local>
References: <483FE9E7.7020707@atmel.com>
	 <20080609124623.5b6bda48@mjolnir.drzeus.cx> <484E4F61.7010007@atmel.com>
	 <20080614182831.0360bd77@mjolnir.drzeus.cx> <4858DDC1.6080802@atmel.com>
	 <20080618104723.GA6788@gateway.home> <20080618111607.GB6788@gateway.home>
	 <20080618114057.GE2226@local>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 12:47:50 +0100
Message-Id: <1213789670.26255.1200.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 13:40 +0200, Hans J. Koch wrote:
> 
> I avoided the German umlaut in my name by using the abbreviation "Hans
> J. Koch" on mailing lists. Unfortunately, I still have one mail client
> that uses the full name. I'll fix that to avoid similar trouble.
> 
> On the other hand, I used that for quite a while now, and didn't have
> problems. It shouldn't be too difficult to have these programs use
> UTF-8 (or any other charset) properly these days.

I'm not convinced it's a problem with rfc2047 handling; I think it's
simpler brain-damage than that on mailman's part. It's to do with line
wrapping, iirc -- if an address spans two lines, like: David Woodhouse
 <dwmw2@infradead.org>, then mailman will brokenly insert a comma where
the line break happened -- or something like that.

-- 
dwmw2

