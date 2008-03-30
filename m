Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbYC3EFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbYC3EFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 00:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbYC3EE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 00:04:59 -0400
Received: from twin.jikos.cz ([213.151.79.26]:41505 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYC3EE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 00:04:59 -0400
Date: Sun, 30 Mar 2008 06:04:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Richard Jonsson <richie@coderworld.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: Keyboard weirdness: keys get stuck
In-Reply-To: <47EEC51C.2060806@coderworld.net>
Message-ID: <Pine.LNX.4.64.0803300603110.32241@twin.jikos.cz>
References: <47EEA097.5000701@coderworld.net> <47EEC51C.2060806@coderworld.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2008, Richard Jonsson wrote:

> > With 2.6.25-rc6-git-something I have experienced stuck keys. When typing a
> > sentence a character repeats aboooooooout 10 times, or as 'about' above ;).
> > I tested with a new kernel today, 2.6.25-rc7-git-something and the problem
> > is still present.
> > With 2.6.25-rc3 the keyboard is fine, and I've not tried with any kernel in
> > between.
> > As a side note, timestamps gets mixed up in dmesg output in a 1-2 second
> > span. Maybe related?
> > This is on a HP dv2140eu laptop, x86_64 SMP. Please cc me if you want
> > configuration details or testing to be done.
> I should add that while watching a movie I noticed that video stutters every
> now and then, on an irregular basis. It lasts for approx a second each time.

Hi Richard,

what does your .config look like? Do you have CONFIG_GCGROUP_SCHED 
enabled? (please note that this is different from CONFIG_GROUP_SCHED). If 
so, please try to reproduce without it.

-- 
Jiri Kosina
SUSE Labs

