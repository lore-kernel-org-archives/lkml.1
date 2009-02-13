Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbZBMNnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbZBMNnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbZBMNnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:43:43 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46420 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbZBMNnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:43:41 -0500
Date: Fri, 13 Feb 2009 13:43:36 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: jbarnes@virtuousgeek.org
Subject: Re: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Message-ID: <20090213134336.GB26549@srcf.ucam.org>
References: <20090213093354.GA10175@denkbrett.schottelius.org> <20090213094048.GC10175@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213094048.GC10175@denkbrett.schottelius.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [ 129.935021] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [ 129.988541] [drm:i915_initialize] *ERROR* can not ioremap virtual address for ring buffer

You need the intel drm for backlight control to work, and it appears to 
be aborting in initialisation. Cc:ing Jesse to get some idea what's 
going on here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
