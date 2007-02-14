Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbXBNJJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbXBNJJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932157AbXBNJJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:09:14 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:41669 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbXBNJJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:09:11 -0500
Date: Wed, 14 Feb 2007 18:07:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: undefined symbol 'PS3_PS3AV'
Message-ID: <20070214090701.GA11088@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Thomas Meyer <thomas@m3y3r.de>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/PPC Development <linuxppc-dev@ozlabs.org>,
	Roman Zippel <zippel@linux-m68k.org>
References: <45D2A835.7020606@m3y3r.de> <Pine.LNX.4.62.0702140955130.17463@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0702140955130.17463@pademelon.sonytel.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 09:57:46AM +0100, Geert Uytterhoeven wrote:
> On Wed, 14 Feb 2007, Thomas Meyer wrote:
> > with 93bbad8fe13a25dcf7f3bc628a71d1a7642ae61b:
> > 
> > drivers/video/Kconfig:1604:warning: 'select' used by config symbol 'FB_PS3'
> > refer to undefined symbol 'PS3_PS3AV'
> 
> It's defined in arch/powerpc/platforms/ps3/Kconfig, which is sourced by
> arch/powerpc/Kconfig only.
> 
> I don't know what's the best way to shut this up. Anyone with a suggestion?
> 
This would seem like a reasonable candidate for a 'depends on' instead of
a select..
