Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbXBJKUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbXBJKUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 05:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXBJKUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 05:20:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45429 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbXBJKUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 05:20:47 -0500
Subject: Re: [git patches] libata updates 1 of 3
From: David Woodhouse <dwmw2@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070210054629.GA4395@gentoox2.trippelsdorf.de>
References: <20070210010914.GA19717@havoc.gtf.org>
	 <20070210054629.GA4395@gentoox2.trippelsdorf.de>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 10:20:09 +0000
Message-Id: <1171102809.29713.221.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-10 at 06:46 +0100, Markus Trippelsdorf wrote:
>  sata_via 0000:00:0f.0 : failed to iomap PCI BAR 0

Zero probably isn't allowed any more. We have to use PCI BAR 1 and
upwards only or the poor driver authors will get confused :)

-- 
dwmw2

