Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbXGNKj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbXGNKj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 06:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbXGNKjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 06:39:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:12586 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbXGNKjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 06:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Uk+3i5ltgEf06S9RZfFxc9BfjTLA77yn1Hr5Y95W+ngfY3jwbmRVc6aszze36cb+Xss/o+7vmATnqcG2Jsn7oCFbtdegaG/B4tWwpV79it1NamCxx/NQ0atJrV+mzcRcA3Dw5fUotOfOh0WvHAUqEIiGhzCznF3NSYKvdWxap00=
Message-ID: <4698A7B6.1030302@googlemail.com>
Date: Sat, 14 Jul 2007 12:38:46 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, netdev@vger.kernel.org
Subject: [PATCH] NET_CLS_RSVP6 should depend on IPV6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

cls_rsvp6 only works with IPV6 enabled kernels and IMO it should depends
on IPV6.


Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

net/sched/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index b466288..200976e 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -299,6 +299,7 @@ config NET_CLS_RSVP
 
 config NET_CLS_RSVP6
        tristate "IPv6 Resource Reservation Protocol (RSVP6)"
+       depends on IPV6
        select NET_CLS
        ---help---
          The Resource Reservation Protocol (RSVP) permits end systems to
@@ -306,7 +307,7 @@ config NET_CLS_RSVP6
          is important for real time data such as streaming sound or video.
 
          Say Y here if you want to be able to classify outgoing packets
based
-         on their RSVP requests and you are using the IPv6.
+         on their RSVP requests and you are using the IPv6 protocol.
 
          To compile this code as a module, choose M here: the
          module will be called cls_rsvp6.


