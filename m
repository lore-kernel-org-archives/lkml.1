Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567Ab0ASWRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0ASWRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278Ab0ASWRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:17:08 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35320 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab0ASWRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:17:01 -0500
Date: Tue, 19 Jan 2010 22:16:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian@openwrt.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-omap@vger.kernel.org
Subject: Re: [RFC] [PATCH] watchdog_info separation and constify
Message-ID: <20100119221647.GC29306@sirena.org.uk>
References: <20100119211759.GE3804@infomag.iguana.be> <1263937351.18117.69.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263937351.18117.69.camel@Joe-Laptop.home>
X-Cookie: Hope is a waking dream.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 01:42:31PM -0800, Joe Perches wrote:

> Maybe a standard #define WATCHDOG_NAME <foo>

> .identity = WATCHGOD_NAME

I don't really see that the indrection via the #define would buy us
anything?
