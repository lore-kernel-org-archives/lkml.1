Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbXCJGVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbXCJGVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbXCJGUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:20:32 -0500
Received: from ns2.suse.de ([195.135.220.15]:41296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbXCJGUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:20:15 -0500
Date: Fri, 9 Mar 2007 22:18:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Johannes Berg <johannes@sipsolutions.net>,
       James Morris <jmorris@namei.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/20] Fix compat_getsockopt
Message-ID: <20070310061827.GP31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-compat_getsockopt.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

[NET]: Fix compat_sock_common_getsockopt typo.

This patch fixes a typo in compat_sock_common_getsockopt.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1597,7 +1597,7 @@ int compat_sock_common_getsockopt(struct
 {
 	struct sock *sk = sock->sk;
 
-	if (sk->sk_prot->compat_setsockopt != NULL)
+	if (sk->sk_prot->compat_getsockopt != NULL)
 		return sk->sk_prot->compat_getsockopt(sk, level, optname,
 						      optval, optlen);
 	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);

-- 
