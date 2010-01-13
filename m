Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009Ab0AMG7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0AMG7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990Ab0AMG7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:59:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1078 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987Ab0AMG7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:59:17 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Samuel Chessman <chessman@tux.org>, linux-media@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH 0/3] A few #define TRUE/FALSE removals
Date: Tue, 12 Jan 2010 22:59:12 -0800
Message-Id: <cover.1263365754.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (3):
  drivers/net/tlan: Remove TRUE/FALSE defines, use bool
  drivers/isdn/mISDN/dsp_ecdis.h: Remove #define TRUE/FALSE, use bool
  drivers/media/dvb/frontends/si21xx.c: Remove #define TRUE/FALSE, use bool

 drivers/isdn/mISDN/dsp_ecdis.h       |   20 +++++++----------
 drivers/media/dvb/frontends/si21xx.c |   38 ++++++++++++++-------------------
 drivers/net/tlan.c                   |   28 ++++++++++++------------
 drivers/net/tlan.h                   |    3 --
 4 files changed, 38 insertions(+), 51 deletions(-)

