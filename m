Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbYGaAEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbYGaAEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbYGaAE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:04:29 -0400
Received: from ns.suse.de ([195.135.220.2]:37708 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYGaAE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:04:28 -0400
Date: Wed, 30 Jul 2008 16:57:52 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 04/62] ipv6: __KERNEL__ ifdef struct ipv6_devconf
Message-ID: <20080730235752.GD12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv6-__kernel__-ifdef-struct-ipv6_devconf.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit ebb36a978131810c98e7198b1187090c697cf99f ]

Based upon a report by Olaf Hering.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ipv6.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -123,6 +123,7 @@ struct ipv6hdr {
 	struct	in6_addr	daddr;
 };
 
+#ifdef __KERNEL__
 /*
  * This structure contains configuration options per IPv6 link.
  */
@@ -165,6 +166,7 @@ struct ipv6_devconf {
 #endif
 	void		*sysctl;
 };
+#endif
 
 /* index values for the variables in ipv6_devconf */
 enum {

-- 
