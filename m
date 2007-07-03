Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXGCPCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXGCPCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759441AbXGCPCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:02:18 -0400
Received: from vz5201.evanzo-server.de ([62.67.245.201]:34981 "EHLO
	vz5201.evanzo-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998AbXGCPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:02:17 -0400
Message-ID: <468A64F0.4000308@boneko.de>
Date: Tue, 03 Jul 2007 17:02:08 +0200
From: Tim Boneko <tim@boneko.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Old bug in tg3 driver unfixed?
References: <46864736.3090108@boneko.de> <20070702235901.GA9713@atjola.homenet>
In-Reply-To: <20070702235901.GA9713@atjola.homenet>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink schrieb:

> Sounds more like a iftab/udev problem. Check /etc/iftab and your udev
> rules please.

The MAC address in /etc/iftab matches that of the card. However, there
are three rules in /etc/udev/rules.d/z25_persistent-net.rules dealing
with eth0 - eth2, they state MAC addresses which don't match. I
certainly didn't put them there. Does udev change its own config?

I will have to check the success when i'm back on location. No use in
decativating the NIC in a ssh session ;-)

Thanks for the hint,

	Tim

