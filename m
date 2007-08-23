Return-Path: <linux-kernel-owner+w=401wt.eu-S933677AbXHWWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677AbXHWWcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932519AbXHWW21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:28:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50724 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765580AbXHWW2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:28:25 -0400
Date: Thu, 23 Aug 2007 15:26:33 -0700
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
       Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 10/28] IPv6: Invalid semicolon after if statement
Message-ID: <20070823222633.GK18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="ipv6-invalid-semicolon-after-if-statement.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

A similar fix to netfilter from Eric Dumazet inspired me to
look around a bit by using some grep/sed stuff as looking for
this kind of bugs seemed easy to automate. This is one of them
I found where it looks like this semicolon is not valid.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ipv6_sockglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -825,7 +825,7 @@ static int ipv6_getsockopt_sticky(struct
 		return 0;
 
 	len = min_t(unsigned int, len, ipv6_optlen(hdr));
-	if (copy_to_user(optval, hdr, len));
+	if (copy_to_user(optval, hdr, len))
 		return -EFAULT;
 	return ipv6_optlen(hdr);
 }

-- 
