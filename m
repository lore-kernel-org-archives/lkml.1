Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbYGYXLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYGYXLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYGYXK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:10:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:58302 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYGYXK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:10:57 -0400
Date: Fri, 25 Jul 2008 16:07:17 -0700
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
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 2/9] ipv6: __KERNEL__ ifdef struct ipv6_devconf
Message-ID: <20080725230717.GC1612@suse.de>
References: <20080725225425.193966072@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0002-ipv6-__KERNEL__-ifdef-struct-ipv6_devconf.patch"
In-Reply-To: <20080725230644.GA1612@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

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
@@ -162,6 +163,7 @@ struct ipv6_devconf {
 #endif
 	void		*sysctl;
 };
+#endif
 
 /* index values for the variables in ipv6_devconf */
 enum {

-- 
