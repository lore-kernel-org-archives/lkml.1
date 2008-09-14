Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbYINRv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbYINRv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 13:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYINRvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 13:51:20 -0400
Received: from www.tglx.de ([62.245.132.106]:51221 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbYINRvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 13:51:19 -0400
Date: Sun, 14 Sep 2008 10:51:04 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
In-Reply-To: <20080914173536.GA1687@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0809141049570.5283@apollo.tec.linutronix.de>
References: <20080912083113.GA1625@elf.ucw.cz> <alpine.LFD.1.10.0809140455470.5283@apollo.tec.linutronix.de> <20080914100913.GB7909@elf.ucw.cz> <20080914101406.GA1625@elf.ucw.cz> <20080914173536.GA1687@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2008, Pavel Machek wrote:
> > It _does_ happen with mainline 2.6.27-rc6.
> 
> s2ram hs problem in mainline 2.6.26, too. (Different problem: no
> ammount pressing shift helps there.) nohz=off cures it, too.

Ok, so it's not a regression.

Is the problem in the suspend path or in the resume ?

Thanks,

	tglx

