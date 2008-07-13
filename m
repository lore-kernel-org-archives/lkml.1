Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYGMVMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYGMVMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbYGMVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:12:36 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:37235 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752909AbYGMVMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:12:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TL0CmPw87Q6RZF76FGMWJrd0cLnvXQRQEdaA5EQrHDbpzAEVop2gOmMyQapXjYIAUevn6/307JxVonlickT3pc9nocPjkBs6oSyx2e9594rPbBTmdsQIZLbdZJ5okPxLi5+fHL9h50eS5AtAN5IJId/A8qGHVeUE8upnMyabimc=  ;
X-YMail-OSG: WuMs8ogVM1kc4THwj9JYwb6M0NdQw3G7cPQgXgI23n5XgEwtz1JBVD9dsQ4qCFGN2EO.scbog_U4.eylojJZxPLOiKjQT3LS6fGqU_2BUg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 1/3] genclk: add generic framework for managing clocks.
Date: Sun, 13 Jul 2008 14:12:32 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
References: <20080708134242.GA6176@doriath.ww600.siemens.net> <20080708134336.GA6240@doriath.ww600.siemens.net> <20080712234823.e632c7f9.akpm@linux-foundation.org>
In-Reply-To: <20080712234823.e632c7f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807131412.32961.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 July 2008, Andrew Morton wrote:
> > +EXPORT_SYMBOL(clk_get_parent);
> 
> As this is a new kernel-wide utility library, it is appropriate that
> all of its public interfaces (at least) be documented.  An appropriate
> way of doing that is via kerneldoc annotation.  Please don't forget to
> document return values and call environment prerequisites (eg: requires
> foo_lock, may be called from interrupt context, etc, etc).

That is, the stuff that's not already documented in <linux/clk.h>;
that's where clk_get_parent() is documented, for example.

I'd suggest a separate (for review!) doc patch to add this to the
stuff that's at the end of Documentation/DocBook/kernel-api.tmpl 
in 2.6.26 ... possibly the existing clk.h interface stuff should
become a <sect1> and the new implementation glue should become
a sibling <sect1>, that will cleanly separate the two.

- Dave
