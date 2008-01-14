Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYANLa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYANLa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYANLaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:30:18 -0500
Received: from rosi.naasa.net ([212.8.0.13]:46821 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbYANLaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:30:17 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Mon, 14 Jan 2008 12:30:12 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <200801071151.11200.lists@naasa.net> <20080114035439.GA7330@mail.ustc.edu.cn> <400304530.01514@ustc.edu.cn>
In-Reply-To: <400304530.01514@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801141230.13694.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Januar 2008 schrieb Fengguang Wu:

> Joerg, this patch fixed the bug for me :-)

Fengguang, congratulations, I can confirm that your patch fixed the bug! With 
previous kernels the bug showed up after each reboot. Now, when booting the 
patched kernel everything is fine and there is no longer any suspicious 
iowait!

Do you have an idea why this problem appeared in 2.6.24? Did somebody change 
the ext2 code or is it related to the changes in the scheduler?

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605

