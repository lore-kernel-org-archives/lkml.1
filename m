Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613Ab0AKIaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0AKIaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587Ab0AKIaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:30:05 -0500
Received: from trinity.fluff.org ([89.16.178.74]:45443 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab0AKIaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:30:03 -0500
Date: Mon, 11 Jan 2010 08:30:02 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Kconfig with multiple sources  of integer value
Message-ID: <20100111083002.GA24987@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a situation (and possibly some more) where having the ability
for multiple options to affect an integer value, in this case ensuring
a minimum value.

currently we have the following:

config S3C24XX_GPIO_EXTRA
        int
        default 128 if S3C24XX_GPIO_EXTRA128
        default 64 if S3C24XX_GPIO_EXTRA64
        default 0

and various machines select S3C24XX_GPIO_EXTRA64 or S3C24XX_GPIO_EXTR128
such as:

config MACH_OSIRIS
       ...
        select S3C24XX_GPIO_EXTRA128


It would be nice if I could say

config S3C24XX_GPIO_EXTRA

and then

config MACH_OSIRIS
       ...
       set_min S3C24XX_GPIO_EXTRA 128

or something similar.


-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

