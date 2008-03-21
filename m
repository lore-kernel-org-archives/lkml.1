Return-Path: <linux-kernel-owner+w=401wt.eu-S1764801AbYCUXBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764801AbYCUXBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763748AbYCUWu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:56 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59315 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763741AbYCUWux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:53 -0400
Message-Id: <20080321224328.611431128@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:42:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephen Hemminger <stephen.hemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 01/76] Revert "NET: Add if_addrlabel.h to sanitized headers."
Content-Disposition: inline; filename=revert-net-add-if_addrlabel.h-to-sanitized-headers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

This reverts commit 5fb7ba76544d95bfa05199f7394a442de5660be7.

It was incorrectly added to the .24.y stable tree and causes build
breakages.

Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 include/linux/Kbuild |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -217,7 +217,6 @@ unifdef-y += i2o-dev.h
 unifdef-y += icmp.h
 unifdef-y += icmpv6.h
 unifdef-y += if_addr.h
-unifdef-y += if_addrlabel.h
 unifdef-y += if_arp.h
 unifdef-y += if_bridge.h
 unifdef-y += if_ec.h

-- 
