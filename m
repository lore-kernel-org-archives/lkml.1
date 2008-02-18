Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbYBRRxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbYBRRxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYBRRxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:53:38 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:50585 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbYBRRxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:53:38 -0500
Date: Mon, 18 Feb 2008 18:53:05 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Laszlo Attila Toth <panther@balabit.hu>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: keyboard dead with 45b5035
Message-ID: <20080218185305.48a67587@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "[RTNETLINK]: Send a single notification on device state changes." kills (at least) the keyboard here. Everything seems to work fine in single user mode, but when init starts spawning of logins, the keyboard goes bye-bye. Even the power button is ignored. :/

I've tried just creating another vt with "chvt 2", but that is insufficient to trigger the bug.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
