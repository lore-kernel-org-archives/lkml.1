Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYGYXKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYGYXKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYGYXKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:10:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:58010 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYGYXKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:10:08 -0400
Date: Fri, 25 Jul 2008 16:06:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 0/9] 2.6.25-stable review
Message-ID: <20080725230644.GA1612@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.13 release.
There are 9 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Monday, July 28, 12:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.13-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team

--------------

 Documentation/networking/udplite.txt |    2 -
 Makefile                             |    2 -
 drivers/net/hamradio/hdlcdrv.c       |    1 
 drivers/net/pppoe.c                  |   37 ++++++++++++++++++-----------------
 drivers/net/pppol2tp.c               |   20 +++++++++++-------
 include/linux/ipv6.h                 |    2 +
 include/linux/kernel.h               |    1 
 net/ipv4/raw.c                       |    2 -
 net/ipv4/udp.c                       |    4 +++
 net/ipv4/xfrm4_mode_tunnel.c         |    2 -
 net/ipv6/ip6_fib.c                   |    4 +--
 11 files changed, 46 insertions(+), 31 deletions(-)
