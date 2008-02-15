Return-Path: <linux-kernel-owner+w=401wt.eu-S1765650AbYBOKJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765650AbYBOKJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYBOKJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:09:25 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:60009 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYBOKJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:09:24 -0500
Date: Fri, 15 Feb 2008 11:09:21 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
Message-ID: <20080215100921.GB5347@ics.muni.cz>
References: <20080214162104.GA5347@ics.muni.cz> <47B4D697.3030106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47B4D697.3030106@gmail.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 15 Feb 2008 11:09:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 09:02:31AM +0900, Tejun Heo wrote:
> > till the scp finishes. It is not caused by low free memory, while scping
> > I have 500MB of free memory (not cached or buffered).
> > 
> > I tried cfq and anticipatory scheduler, none is different.
> > 
> 
> Does deadline help?

well, deadline is a little bit better. I'm trying to read from disk opening
maildir with 20000 mails with mutt. If I open that maildir, mutt shows
progress. With cfq or anticipatory scheduler, progress is 0/20000 until scp
finishes. With deadline, progress is 150/20000 after scp finished. So I would
say, it is better but I doubt it is OK.

-- 
Luká¹ Hejtmánek
