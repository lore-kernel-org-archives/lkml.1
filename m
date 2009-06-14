Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZFNKey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZFNKey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZFNKeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:34:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbZFNKeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:34:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Benjamin S." <sbenni@gmx.de>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Date: Sun, 14 Jun 2009 12:35:24 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, js@sig21.net
References: <20090614120950.116536fa@pluto-lenny.milky.way>
In-Reply-To: <20090614120950.116536fa@pluto-lenny.milky.way>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141235.24942.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Benjamin S. wrote:
> 
> Hi,
> 
> I think I have the same problem Johannes has posted there:
> 
> http://marc.info/?l=linux-kernel&m=124475174614672&w=2
> 
> My motherboard is a Gigabyte GA-MA78G-DS3H rev. 1.0 (chipset SB700 - the 
> same as Johannes' chipset) and my CPU is a AMD 4850e (also the same
> as Johannes' CPU). Thus I see the same error on resume after suspend
> to memory:

Thanks for the report, the problem seems to be related to the chipset, because
I'm unable to reproduce it with SB600 and a fairly new AMD CPU.

Does the resume work if you comment out suspend_device_irqs() and
resume_device_irqs() in drivers/base/power/main.c ?

Rafael
