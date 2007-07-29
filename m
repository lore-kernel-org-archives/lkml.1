Return-Path: <linux-kernel-owner+w=401wt.eu-S936924AbXG2VY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936924AbXG2VY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936114AbXG2VYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:24:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49424 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935579AbXG2VYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:24:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: [PATCH] ppc: chipsfb.c build fix for CONFIG_PM
Date: Sun, 29 Jul 2007 23:33:11 +0200
User-Agent: KMail/1.9.5
Cc: paulus@samba.org, Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <200707291950.30261.m.kozlowski@tuxland.pl>
In-Reply-To: <200707291950.30261.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707292333.12766.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 July 2007 19:50, Mariusz Kozlowski wrote:
> Hello,
> 
> 	This patch fixes the following build error on powerpc:
> 
>   CC      drivers/video/chipsfb.o
> drivers/video/chipsfb.c: In function 'chipsfb_pci_suspend':
> drivers/video/chipsfb.c:461: error: 'PM_SUSPEND_MEM' undeclared (first use in this function)
> drivers/video/chipsfb.c:461: error: (Each undeclared identifier is reported only once
> drivers/video/chipsfb.c:461: error: for each function it appears in.)
> make[2]: *** [drivers/video/chipsfb.o] Blad 1
> make[1]: *** [drivers/video] Blad 2
> make: *** [drivers] Blad 2

Already fixed in the right way.  Please see:
http://www.mail-archive.com/mm-commits@vger.kernel.org/msg22171.html

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
