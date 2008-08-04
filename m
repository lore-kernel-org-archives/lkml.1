Return-Path: <linux-kernel-owner+w=401wt.eu-S1764154AbYHDU2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764154AbYHDU2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764081AbYHDU1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:27:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:45916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764073AbYHDU1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:27:47 -0400
Date: Mon, 4 Aug 2008 13:15:58 -0700
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
       alan@lxorguk.ukuu.org.uk,
       "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
       "John W. Linville" <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [patch 20/33] ath5k: Use software encryption for now
Message-ID: <20080804201558.GU1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ath5k-use-software-encryption-for-now.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

Commit 6844e63a9458d15b4437aa467c99128d994b0f6c

Hardware encryption doesn't work yet so lets use software
encryption for now.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath5k/base.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2864,7 +2864,9 @@ ath5k_set_key(struct ieee80211_hw *hw, e
 
 	switch(key->alg) {
 	case ALG_WEP:
-		break;
+	/* XXX: fix hardware encryption, its not working. For now
+	 * allow software encryption */
+		/* break; */
 	case ALG_TKIP:
 	case ALG_CCMP:
 		return -EOPNOTSUPP;

-- 
