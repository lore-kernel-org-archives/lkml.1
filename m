Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYKZTRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYKZTRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYKZTRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:17:09 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:28177 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYKZTRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:17:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FQg9hHV1n456hDzvfgpW87rYGcBLZKeIVPzWnTLs1Heo5Tn7njhPLnzJJ+2qjPAY10
         h7s5zTh6+0A39Nliiw0jmJjPM2wp36bsqrhrnbPWdhmX3kDk1+QCIUZuYTwnvqutwJMv
         ozpFikTd0SzmMnYgtR/xJAW95jdeZJFoh1wLg=
From: gorcunov@gmail.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: x86 -tip: entry_64.S cleanup series
Date: Wed, 26 Nov 2008 22:16:59 +0300
Message-Id: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.4.603.gbc9c0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi, here is a trivial cleanups for entry_64.S,
please review. The dangerous one is patch 2: get rid
of back jump -- check it twice.

Alexander, I hope it doesn't interfere with the stuff
you are working on?

		- Cyrill -


