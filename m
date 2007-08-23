Return-Path: <linux-kernel-owner+w=401wt.eu-S933693AbXHWWda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbXHWWda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933101AbXHWW26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:28:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50811 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbXHWW24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:28:56 -0400
Date: Thu, 23 Aug 2007 15:26:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/28] Netfilter: Missing Kbuild entry for netfilter
Message-ID: <20070823222651.GM18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netfilter-missing-kbuild-entry-for-netfilter.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chuck Ebbert <cebbert@redhat.com>

Add xt_statistic.h to the list of headers to install.

Apparently needed to build newer versions of iptables.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/netfilter/Kbuild |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -28,6 +28,7 @@ header-y += xt_policy.h
 header-y += xt_realm.h
 header-y += xt_sctp.h
 header-y += xt_state.h
+header-y += xt_statistic.h
 header-y += xt_string.h
 header-y += xt_tcpmss.h
 header-y += xt_tcpudp.h

-- 
