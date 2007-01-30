Return-Path: <linux-kernel-owner+w=401wt.eu-S1751184AbXA3QRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbXA3QRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXA3QRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:17:32 -0500
Received: from ns2.suse.de ([195.135.220.15]:41936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbXA3QRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:17:31 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] VIA IRQ quirk breakage fix
Date: Tue, 30 Jan 2007 17:17:08 +0100
User-Agent: KMail/1.9.1
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Sergey Vlasov <vsu@altlinux.ru>,
       Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
References: <45B6A94A.3010006@yahoo.com.au> <200701301449.52147.jdelvare@suse.de> <20070130162151.2a0e8bf1@localhost.localdomain>
In-Reply-To: <20070130162151.2a0e8bf1@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701301717.08792.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mardi 30 Janvier 2007 17:21, Alan a écrit :
> On Tue, 30 Jan 2007 14:49:51 +0100 Jean Delvare wrote:
> > I do believe this is 2.6.20 material. Given that Alan's version doesn't
> > work _at all_, my patch can only help. The real regression is between
> > 2.6.19 and the current Linus tree (with Alan's quirk.)
>
> I believe my version works for all but the 686B

It would if pci_find_present() was working at quirk time, which apparently 
isn't the case in Linus' tree. And the bug report I received was on a VT8233.

-- 
Jean Delvare
Suse L3
