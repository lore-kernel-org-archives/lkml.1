Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbYEWS2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbYEWS2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYEWS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:27:57 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2896 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751792AbYEWS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:27:56 -0400
Date: Fri, 23 May 2008 22:27:54 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Cc: Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [RFC] OpenFirmware bindings for the MMC-over-SPI driver
Message-ID: <20080523182754.GA26891@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is second attempt to write the OpenFirmware bindings for the
MMC-over-SPI (and SPI bindings in general). First attempt[1] was discussed
in the linuxppc-dev list only, since I tried to do the bindings without
touching the drivers them self. That attempt got a cool welcome, so here
is an alternative.

Grant, I'm somewhat sure you'll like it now... :-) As a plus, these
bindings doesn't require changes to the spi_of core...

[1] http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056727.html

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
