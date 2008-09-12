Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbYILVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbYILVFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYILVFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:05:41 -0400
Received: from www.tglx.de ([62.245.132.106]:56797 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbYILVFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:05:40 -0400
Date: Fri, 12 Sep 2008 23:05:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
In-Reply-To: <200809122245.45723.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0809122303210.13819@apollo.tec.linutronix.de>
References: <20080912083113.GA1625@elf.ucw.cz> <200809122117.05750.rjw@sisk.pl> <alpine.LFD.1.10.0809122113270.13819@apollo.tec.linutronix.de> <200809122245.45723.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, Rafael J. Wysocki wrote:
> > > We seem to be doing a "one step forward, one step back" thing here ...
> > 
> > Well, the fixes for HPET/clockevents fix real bugs and there are no
> > evident side effects vs. s2ram inside. quite the contrary.
> 
> So that must be something different.

well, there is no way to exclude those patches for sure, but Pavel
should be able to identify the one which causes problems.

Thanks,

	tglx
 
