Return-Path: <linux-kernel-owner+w=401wt.eu-S1758998AbXLQNRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998AbXLQNRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbXLQNRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:17:37 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:52899 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbXLQNRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:17:36 -0500
Date: Mon, 17 Dec 2007 14:17:26 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: swapping in 2.6.24-rc5-git3
Message-ID: <20071217131726.GA14091@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 17 Dec 2007 14:17:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

does /proc/sys/vm/swappiness still work as expected? 
# /proc/sys/vm# cat swappiness 
0

but scp-ing 2GB file causes many processes are swapped out due to increase of
the file cache size. Why? This is totally catastrophic behaviour on the desktop.

Is there a way to avoid it except turning off the swap?

-- 
Luká¹ Hejtmánek
