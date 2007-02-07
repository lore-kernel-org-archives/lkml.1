Return-Path: <linux-kernel-owner+w=401wt.eu-S1161234AbXBGL5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161234AbXBGL5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161237AbXBGL5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:57:09 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:41779 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161234AbXBGL5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:57:08 -0500
Date: Wed, 7 Feb 2007 12:57:04 +0100
From: Eduard Bloch <edi@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.20 regression] No text console picture after X start
Message-ID: <20070207115704.GA4343@rotes76.wohnheim.uni-kl.de>
References: <20070207111953.GA4105@rotes76.wohnheim.uni-kl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070207111953.GA4105@rotes76.wohnheim.uni-kl.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

#include <hallo.h>
* Eduard Bloch [Wed, Feb 07 2007, 12:19:53PM]:
> Hello,
> 
> I have an ATI Radeon X800 GTO card [1], which works "well"[2] with
> xserver-xorg-video-ati 6.6.3-2 (Debian Sid). However, after upgrading to
> 2.6.20, the console screen is no longer restored after switching the
> virtual terminal to first console when X has been started once.
> Apparently the keyboard input does work but the picture is frozen at the
> last image seen in X and some colors become changed (like on wrong color
> pallette mapping).

Sorry, was a false alarm. The reason seems to be a problem with the X
server which happens to crash frequently, and console is broken only
after that happened.

Eduard.

-- 
Manch einer ist so überzeugt, er weiß gar nicht mehr wovon.
