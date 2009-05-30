Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbZE3W7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbZE3W7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758136AbZE3Wyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:54:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46820 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759507AbZE3Wyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:54:39 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander V. Lukyanov" <lav@yar.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Neil Horman" <nhorman@tuxdriver.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A.S6F.dVbIKB@chimera>
Subject: [Bug #13339] rtable leak in ipv4/route.c
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13339
Subject		: rtable leak in ipv4/route.c
Submitter	: Alexander V. Lukyanov <lav@yar.ru>
Date		: 2009-05-18 14:10 (13 days old)


