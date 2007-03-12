Return-Path: <linux-kernel-owner+w=401wt.eu-S965481AbXCLKCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965481AbXCLKCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965469AbXCLKCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:02:47 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43374 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965466AbXCLKCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:02:46 -0400
Date: Mon, 12 Mar 2007 11:02:43 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jeff Garzik <jeff@garzik.org>, Jay Vosburgh <fubar@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
In-Reply-To: <20070306114808.GA22724@havoc.gtf.org>
Message-ID: <Pine.LNX.4.62.0703121100260.16343@pademelon.sonytel.be>
References: <20070306114808.GA22724@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Jeff Garzik wrote:
> Jay Vosburgh (3):
>       bonding: Improve IGMP join processing

ip_mc_rejoin_group: Kill warning about unused variable `in_dev' when
CONFIG_IP_MULTICAST is not set.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 1c6a084..8cedb2a 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1255,9 +1255,9 @@ out:
  */
 void ip_mc_rejoin_group(struct ip_mc_list *im)
 {
+#ifdef CONFIG_IP_MULTICAST
 	struct in_device *in_dev = im->interface;
 
-#ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
