Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbYBPQNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbYBPQNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYBPQN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:13:27 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:58360 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbYBPQN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:13:26 -0500
Date: Sat, 16 Feb 2008 17:13:10 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Zan Lynx <zlynx@acm.org>
Cc: Prakash Punnoor <prakash@punnoor.de>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
Message-ID: <20080216161310.GG4269@ics.muni.cz>
References: <20080214162104.GA5347@ics.muni.cz> <Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr> <200802151557.59082.prakash@punnoor.de> <1203095486.6663.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1203095486.6663.12.camel@localhost>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 16 Feb 2008 17:13:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 10:11:26AM -0700, Zan Lynx wrote:
> Yes, I see this often myself.  It's like the disk IO queue (I set mine
> to 1024) fills up, and pdflush and friends can stuff write requests into
> it much more quickly than any other programs can provide read requests.
> 
> CFQ and ionice work very well up until iostat shows average IO queuing
> above 1024 (where I set the queue number).

I though that CFQ would maintain IO queues per process and pick up request in
round robin from non-empty queues. Am I wrong? And if wrong, isn't it desired
behavior for desktop?

-- 
Luká¹ Hejtmánek
