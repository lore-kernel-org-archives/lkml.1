Return-Path: <linux-kernel-owner+w=401wt.eu-S965649AbXA3Rsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965649AbXA3Rsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965650AbXA3Rsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:48:38 -0500
Received: from [139.30.44.16] ([139.30.44.16]:8403 "EHLO
	gockel.physik3.uni-rostock.de" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965649AbXA3Rsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:48:37 -0500
Date: Tue, 30 Jan 2007 18:48:33 +0100 (CET)
From: Tim Schmielau <tim@physik3.uni-rostock.de>
To: Tom Burns <tom.i.burns@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: 2.6.15 Process accounting fails to account for small time
 slice loads (still)
In-Reply-To: <671c20540701300824p54dad7dbw43fe916bc8c98d45@mail.gmail.com>
Message-ID: <Pine.LNX.4.63.0701301840470.14441@gockel.physik3.uni-rostock.de>
References: <671c20540701300824p54dad7dbw43fe916bc8c98d45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Tom Burns wrote:

> The bug described back in 2004 in the following message still seems to exist:
> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-05/4313.html
> 
> Essentially, it appears that if a process sleeps before it uses up a
> complete jiffy then no charge is made to its process accounting table.

That's not a bug, it's a feature. ;-)

More seriously, it's a design decision. The benefit of exactly correct 
micro bookkeeping does not seem to warrant the extra cost in terms of cpu 
cycles spent in the accounting code.

IIRC there was a patch for that some years ago, if you are interested I 
will try to find it. No idea how much work it would be to port it to 
current kernels, though.

Tim
