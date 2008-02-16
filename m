Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYBPQPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYBPQPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYBPQPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:15:30 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:40288 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbYBPQP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:15:29 -0500
Date: Sat, 16 Feb 2008 17:15:26 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Paulo Marques <pmarques@grupopie.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
Message-ID: <20080216161526.GH4269@ics.muni.cz>
References: <20080214162104.GA5347@ics.muni.cz> <47B5CAE4.1000905@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47B5CAE4.1000905@grupopie.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 16 Feb 2008 17:15:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 05:24:52PM +0000, Paulo Marques wrote:
> If you want to take advantage of all that memory to buffer disk writes,  
> so that the reads can proceed better, you might want to tweak your  
> /proc/sys/vm/dirty_ratio amd /proc/sys/vm/dirty_background_ratio to more  
> appropriate values. (maybe also dirty_writeback_centisecs and  
> dirty_expire_centisecs)

I don't feel like to have my whole memory eaten by a single file which is not
to be read again and thus it is pretty useless. Instead, I would like to see
slowdown of scp so that other processes can also access disk. Why is this
possible with kernel process scheduler and not with IO scheduler?

-- 
Luká¹ Hejtmánek
