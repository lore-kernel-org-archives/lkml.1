Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYFISQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYFISQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYFISQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:16:07 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:63099 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYFISQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=WsW1U6ACdBT3LVZWE0IOEXpU90ymq0YMy5ey5FuBZxLsA+291IOr0tr+9+wjCshSQp
         fmOKNci3FW7JooOwD4dOS30gwZ36ltkHVaaC5ibkC7QPqzHlp/6/EO2IjAtRRqoP4q8D
         /UFvyCl5jmi4dsYwvKZdYp4xd2ItoORvOEiPM=
Message-ID: <5da0588e0806091116l31344cdfp90b3407abdaea345@mail.gmail.com>
Date: Mon, 9 Jun 2008 14:16:03 -0400
From: Rince <rincebrain@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] rt_worker_func panics on my Asus motherboard
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi LKML,
I've got an Asus P5BV-C/4L motherboard - somewhat badly supported
pre-2.6.25. Debian and Ubuntu stable refused to boot their install CDs
on it...but I digress.

I couldn't run 2.6.24 on it - it hung forever on initializing the SATA
ports. So I booted a GIT kernel (Git from May 31st at around 10 PM),
and hurray, it worked correctly.

Unfortunately, recently, the server went down. I turned on the
monitor, and a wonderful panic greeted me (scrolled a few lines off
the top, "of course"). I did not have a good camera handy, but I can
transcribe it in parts as requested. Below is the call trace:

[<ffffffff803b8582>]rt_worker_func+0x0/0x16c
[<ffffffff8023dc95>]run_workqueue+0x7b/0x103
[<ffffffff8023e533>]worker_thread+0xd5/0xe0
[<ffffffff80240d19>]autoremove_wake_function+0x0/0x2e
[<ffffffff8023e45e>]worker_thread+0x0/0xe0
[...]

My kernel config can be found on acm.jhu.edu/~rercola/astrolabe-config.gz

Any additional information I can provide, I will be more than willing
to. I've linked this to one or two questionable pieces of networking
hardware I have laying around, so I can reproduce it freely.

Thanks to anyone who can shed light on this!
- Rich
-- 
Wrinkles should merely indicate where smiles have been. -- Mark Twain
