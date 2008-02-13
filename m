Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYBMF5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYBMF5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYBMF5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:57:38 -0500
Received: from gherkin.frus.com ([192.158.254.49]:36867 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYBMF5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:57:38 -0500
X-Greylist: delayed 1713 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 00:57:37 EST
Subject: [REGRESSION] 2.6.25-rc1 does not boot on Alpha
To: linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2008 23:29:03 -0600 (CST)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080213052903.B1F1CDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't going to be terribly useful other than giving someone a
heads-up there's a problem with something in 2.6.25-rc1 on the Alpha
PWS 433au.  I get the usual messages out of "aboot", including

aboot: zero-filling 210392 bytes at 0xfffffc0000776740
aboot: starting kernel vmlinux.new.gz with argument ro root=/dev/sda3

and then the screen background switches to red and the machine locks
up solid.  No further console output.  Completely reproducible.  The
2.6.24 kernel is fine.

Unless someone has a good idea what's causing this, I see a massive
"git bisect" project in my future.  Won't be able to spend any time with
this until at least the weekend :-(.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
