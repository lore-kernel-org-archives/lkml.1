Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbZHGRCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbZHGRCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbZHGRCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:02:07 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2083 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbZHGRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:02:05 -0400
Subject: [PATCH] REPORTING-BUGS: Add get_maintainer.pl blurb
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: sposelenov@emcraft.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
In-Reply-To: <20090807.090353.191304972.davem@davemloft.net>
References: <20090618183738.662f7ef1@emcraft.com>
	 <20090807153106.335b1b8f@emcraft.com>
	 <20090807.090353.191304972.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 10:01:55 -0700
Message-Id: <1249664515.3467.83.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index ab0c566..55a6074 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -15,7 +15,10 @@ worry too much about getting the wrong person. If you are unsure send it
 to the person responsible for the code relevant to what you were doing.
 If it occurs repeatably try and describe how to recreate it. That is
 worth even more than the oops itself.  The list of maintainers and
-mailing lists is in the MAINTAINERS file in this directory.
+mailing lists is in the MAINTAINERS file in this directory.  If you
+know the file name that causes the problem you can use the following
+command in this directory to find some of the maintainers of that file:
+     perl scripts/get_maintainer.pl -f <filename>
 
       If it is a security bug, please copy the Security Contact listed
 in the MAINTAINERS file.  They can help coordinate bugfix and disclosure.


