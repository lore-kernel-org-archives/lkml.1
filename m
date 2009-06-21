Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbZFUMal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbZFUMal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 08:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZFUMad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 08:30:33 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59064 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZFUMad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 08:30:33 -0400
Date: Sun, 21 Jun 2009 14:30:34 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@googlemail.com>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Acer Aspire One fan control, simplified and scrubbed
Message-ID: <20090621123034.GA21764@rhlx01.hs-esslingen.de>
References: <20090620170835.GA3295@liondog.tnic> <20090620203846.bbe19d0d.peter@piie.net> <20090621060216.GA25786@liondog.tnic> <cone.1245587130.876104.5395.1000@onepiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1245587130.876104.5395.1000@onepiie>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 21, 2009 at 02:25:30PM +0200, Peter Feuerer wrote:
> Ok, we'll leave this feature out, as the code is really much cleaner and 
> I also doubt that anybody will miss it.

Either that, or, if one implements it, then one should probably do it in a
watchdog type way (i.e. expect new userspace input at least every 20 seconds,
otherwise emergency-switch back to kernel mode or maybe better even BIOS mode).
One molten machine less, ya know ;)

(would be good to add this as a comment in the driver patch, "if one intends
to add userspace control, then please watchdog...")

Andreas Mohr
