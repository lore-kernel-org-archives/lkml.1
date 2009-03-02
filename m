Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbZCBT4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbZCBT4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbZCBTzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:55:54 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:52763 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbZCBTzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:55:53 -0500
Date: Mon, 2 Mar 2009 20:55:48 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
Message-ID: <20090302205548.223003d5@mjolnir.ossman.eu>
In-Reply-To: <499D4CB6.3070807@nokia.com>
References: <4991A00B.8040002@nokia.com>
	<20090211133004.GH478@console-pimps.org>
	<4992D90E.10506@nokia.com>
	<4992E597.2030404@nokia.com>
	<20090218211627.7c16339a@mjolnir.ossman.eu>
	<499D0B5C.4000005@nokia.com>
	<20090219112243.GB25903@console-pimps.org>
	<499D4CB6.3070807@nokia.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 14:12:38 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> 
> No it is my mistake.  The value is 8 but the unit is 8 clock cycles
> i.e. 64 clock cycles.  So my comment was wrong.
> 

That was an annoyingly confusing way of writing a spec.

Could you fix up the comment and the if-clause and we'll have this in
for .29.

Thanks
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
