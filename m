Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYKNRFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYKNRFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYKNRFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:05:45 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51319 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbYKNRFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:05:44 -0500
Subject: 2.6.27.6 undefined reference to mii_ethtool_gset in r8169
From: Kasper Sandberg <lkml@metanurb.dk>
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 18:05:41 +0100
Message-Id: <1226682341.19624.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I was helping a friend compile his kernel and got the error about the
undefined reference.. grepping showed it was there, and exported, so i
proceded to add mii.o to drivers/net/Makefile like this:

obj-$(CONFIG_R8169) += mii.o r8169.o

and starts the build again, and it succeeded..


mvh.
Kasper Sandberg

