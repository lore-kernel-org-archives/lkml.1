Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbXBDAXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbXBDAXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXBDAXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:23:04 -0500
Received: from gockel.physik3.uni-rostock.de ([139.30.44.16]:18613 "EHLO
	gockel.physik3.uni-rostock.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbXBDAXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:23:03 -0500
Date: Sun, 4 Feb 2007 01:22:59 +0100 (CET)
From: Tim Schmielau <tim@physik3.uni-rostock.de>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Richard Knutsson <ricknu-0@student.ltu.se>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: A CodingStyle suggestion
In-Reply-To: <20070204000532.GA20721@Ahmed>
Message-ID: <Pine.LNX.4.63.0702040120001.5396@gockel.physik3.uni-rostock.de>
References: <20070203215848.GA10440@Ahmed> <45C51310.6070304@student.ltu.se>
 <20070204000532.GA20721@Ahmed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007, Ahmed S. Darwish wrote:
> On Sat, Feb 03, 2007 at 11:56:16PM +0100, Richard Knutsson wrote:
> > So:
> > 
> > if (is_true()) {
> > 	/* do something */
> > }
> > 
> > is alright then? If so, I agree, but please make it real clear in the 
> > document ;)
> 
> Good catch :). A small grep of `access_ok' reveals that it's always used in the 
> form of:
> if (!access_ok()) { .. }
> 
> I can conclude that verbal/imperative methods like `kmalloc, add_work' be 
> checked as:
> ret = do_work();
> if (ret) { ... }
> and predicate methods like `acess_ok, pci_dev_present' be checked like:
> if (!access_ok) { ... }
> if (pci_dev_present) { ...}

Maybe say that any functions with a side effect should be called on a line 
by themselves?

Tim
