Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYAPQrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYAPQrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYAPQrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:47:00 -0500
Received: from host-66-43-248-10 ([67.55.143.10]:39542 "EHLO
	thinix-laptop.local.rdi1.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752184AbYAPQq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:46:59 -0500
X-Greylist: delayed 1180 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2008 11:46:59 EST
Subject: unionfs, cow, and whiteout
From: Paul Albrecht <albrecht@rdi1.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Jan 2008 10:27:13 -0600
Message-Id: <1200500833.11000.0.camel@thinix-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question about how unionfs handles file deletion when a write
enabled file system is union mounted over a read only file system. For
example, I do something like the following:

mount -t unionfs -o dirs=/cow=rw:/rofs=ro unionfs /mnt

If I create and delete a file in /mnt which is not present in /rofs it
persists as whiteout in the cow file system which is not what I would
have expected.

Why does the deleted file persist as whiteout in the /cow file system of
the union mount?

Please cc me in your response as I'm not subscribed to the lkml.

-- 

Paul Albrecht
