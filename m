Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYIGAaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYIGAaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 20:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYIGAaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 20:30:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:62322 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbYIGAaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 20:30:00 -0400
To: linux-kernel@vger.kernel.org
Cc: Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH 0/1] EHCI handoff failure timeout too long
Date: Sat,  6 Sep 2008 17:29:52 -0700
Message-Id: <1220747393-10401-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.1
From: Steven Noonan <steven.noonan@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all. I've got an HP dv5178us notebook with an apparent BIOS
bug in which it doesn't properly report that it's completed the
EHCI handoff. Unfortunately, this causes a 5 second snag at
every boot. This is -much- too long in my opinion.

My resolution for the issue is simply to cut the 5 seconds down
to 0.5 seconds. I am unsure whether changing the timeout is
wise, though, because I suppose it's possible that a buggy BIOS
could announce the success of the handoff -after- the timeout.

Thoughts?

Steven Noonan (1):
  drivers/usb/host/pci-quirks.c: wait for EHCI handoff far too long in
    quirk_usb_disable_ehci()

 drivers/usb/host/pci-quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

