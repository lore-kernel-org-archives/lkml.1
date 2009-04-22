Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZDVIlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZDVIlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZDVIlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:41:09 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:52386
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbZDVIlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:41:08 -0400
Date: Wed, 22 Apr 2009 10:41:04 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: linux-next: Tree for April 22 [BUG] ep93xx_keypad_open:
	undefined reference to `clk_set_rate'
Message-ID: <20090422084104.GB20105@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	H Hartley Sweeten <hartleys@visionengravers.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <20090422154247.dbffd285.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422154247.dbffd285.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

the driver for the Cirrus Logic EP93xx keypad matrix relies on the
function clk_set_rate() which (still) isn't defined for ep93xx:

drivers/built-in.o: In function `ep93xx_keypad_open':
hid-quirks.c:(.text+0x61aa0): undefined reference to `clk_set_rate'

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

              You can't separate peace from freedom because no
               one can be at peace unless he has his freedom
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
