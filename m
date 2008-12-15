Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYLOJoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYLOJoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 04:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYLOJnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 04:43:52 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:46161 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbYLOJnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 04:43:51 -0500
Date: Mon, 15 Dec 2008 10:44:09 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081215094409.GA4422@ics.muni.cz>
References: <20081212183810.GA4390@ics.muni.cz> <20081213012115.GA6250@localhost> <20081213095815.GA7143@ics.muni.cz> <20081215011645.GA9707@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081215011645.GA9707@localhost>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 15 Dec 2008 10:43:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 09:16:45AM +0800, Wu Fengguang wrote:
> Lukas, could you apply the attached patch, recompile and do
> 
> modprobe filecache
> free; cp /proc/filecache /tmp/a;
> echo 3 > /proc/sys/vm/drop_caches
> free; cp /proc/filecache /tmp/b;
> 
> and send me the outputs a and b?

unfortunately, it causes an oops (0000 [#1] SMP) in d_path + 0x31/0x110, code
48 85 c0 74 2f <48> 8b 40 30 48
rax = 0x100000001

(it does not save the oops into any log, thus I only wrote down possibly most
important clues)

-- 
Luká¹ Hejtmánek
