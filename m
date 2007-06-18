Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbXFRLOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbXFRLOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbXFRLOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:14:35 -0400
Received: from mail4.kite.se ([212.214.165.225]:57739 "EHLO mail4.kite.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbXFRLOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:14:35 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 07:14:35 EDT
Message-ID: <4676679E.5040901@kite.se>
Date: Mon, 18 Jun 2007 13:08:14 +0200
From: Magnus Naeslund <mag@kite.se>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ARC-1260: No space left on device, when there is (or should be) free
 space left
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems I have a problem accessing the whole device, it filled up too quickly.
I thought I was avoiding the 2tb limit when not using any partition tables, shame on me :)

# df -B 1 /dev/sdb
Filesystem           1B-blocks      Used Available Use% Mounted on
/dev/sdb             5999417057280 1908287229952 4091129827328  32% /storage/disk1

(Ok here I have 68% free space on our 5.5TB device)

# echo zzz > /storage/disk1/dummy
/storage/disk1/dummy: No space left on device

(But here it seems to think the device is full)

It's an amd64 based system running 2.6.21.5.
Please tell me if you need more information!

Regards,
Magnus

