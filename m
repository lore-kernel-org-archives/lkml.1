Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbZCNAkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbZCNAkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZCNATg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:36 -0400
Received: from kroah.org ([198.145.64.141]:34833 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750871AbZCNATX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:48 2009
Message-Id: <20090314000748.415908501@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:10 -0700
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
       alan@lxorguk.ukuu.org.uk, Francois Romieu <romieu@fr.zoreil.com>,
       Jeff Garzik <jgarzik@redhat.com>, Daniel Drake <dsd@gentoo.org>
Subject: [patch 62/96] sis190: add identifier for Atheros AR8021 PHY
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=sis190-add-identifier-for-atheros-ar8021-phy.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit 708f6e27c3f75166433b69174a8348308e55d073 upstream.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=10994

Contributed by pablomme@googlemail.com, coenraad@wish.org.za
and a few others.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sis190.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/sis190.c
+++ b/drivers/net/sis190.c
@@ -317,6 +317,7 @@ static struct mii_chip_info {
         unsigned int type;
 	u32 feature;
 } mii_chip_table[] = {
+	{ "Atheros PHY AR8012",   { 0x004d, 0xd020 }, LAN, 0 },
 	{ "Broadcom PHY BCM5461", { 0x0020, 0x60c0 }, LAN, F_PHY_BCM5461 },
 	{ "Broadcom PHY AC131",   { 0x0143, 0xbc70 }, LAN, 0 },
 	{ "Agere PHY ET1101B",    { 0x0282, 0xf010 }, LAN, 0 },


