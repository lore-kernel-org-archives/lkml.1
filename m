Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbYIOOIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbYIOOIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 10:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYIOOIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 10:08:35 -0400
Received: from www.tglx.de ([62.245.132.106]:55754 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbYIOOIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 10:08:34 -0400
Date: Mon, 15 Sep 2008 07:08:01 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
In-Reply-To: <20080915091925.GB1787@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0809150704420.5283@apollo.tec.linutronix.de>
References: <20080912083113.GA1625@elf.ucw.cz> <alpine.LFD.1.10.0809140455470.5283@apollo.tec.linutronix.de> <20080914100913.GB7909@elf.ucw.cz> <20080914101406.GA1625@elf.ucw.cz> <20080914173536.GA1687@elf.ucw.cz> <alpine.LFD.1.10.0809141049570.5283@apollo.tec.linutronix.de>
 <20080914181228.GA18934@elf.ucw.cz> <alpine.LFD.1.10.0809141214110.5283@apollo.tec.linutronix.de> <20080915091925.GB1787@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008, Pavel Machek wrote:
> > 
> > Hmm. Can you please provide the output of /proc/timer_list when the
> > system is in that "sleepy" state.

Any chance to get that output ?
 
> -rc5 seems to work ok... is there some patch I should try to revert
> first?

The relevant 9 changes are from:

7c1e76897492d92b6a1c2d6892494d39ded9680c

to

72d43d9bc9210d24d09202eaf219eac09e17b339

Thanks,

	tglx
