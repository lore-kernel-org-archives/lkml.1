Return-Path: <linux-kernel-owner+w=401wt.eu-S1764521AbZCNBnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764521AbZCNBnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZCNBVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:07 -0400
Received: from kroah.org ([198.145.64.141]:35408 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754230AbZCNBUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:40 2009
Message-Id: <20090314011040.746463995@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:40 -0700
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
       alan@lxorguk.ukuu.org.uk, Rabin Vincent <rabin@rab.in>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 063/114] mmc_test: fix basic read test
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=mmc_test-fix-basic-read-test.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rabin Vincent <rabin@rab.in>

commit 58a5dd3e0e77029d3db1f8fa75d0b54b38169d5d upstream.

Due to a typo in the Basic Read test, it's currently identical to the
Basic Write test.  Fix this.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/card/mmc_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -494,7 +494,7 @@ static int mmc_test_basic_read(struct mm
 
 	sg_init_one(&sg, test->buffer, 512);
 
-	ret = mmc_test_simple_transfer(test, &sg, 1, 0, 1, 512, 1);
+	ret = mmc_test_simple_transfer(test, &sg, 1, 0, 1, 512, 0);
 	if (ret)
 		return ret;
 


