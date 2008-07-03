Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYGCVTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYGCVTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYGCVTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:19:42 -0400
Received: from khc.piap.pl ([195.187.100.11]:57908 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbYGCVTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:19:41 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Add missing skb->dev assignment in Frame Relay RX code.
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 03 Jul 2008 23:19:38 +0200
Message-ID: <m3bq1ey8b9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

How about the Frame-Relay fix, would you like me to repost it?

Alternatively you can get it from (based on 2.6.25):
git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git hdlc-fixes

aka (on *.kernel.org):
/pub/scm/linux/kernel/git/chris/linux-2.6.git	hdlc-fixes

It contains:
$ git-diff --stat v2.6.25
 drivers/net/wan/hdlc_fr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

I'd be glad if it makes it to 2.6.26, it's a) obvious,
b) security-related, c) extra short, d) nobody objected

Thanks in advance.
-- 
Krzysztof Halasa
