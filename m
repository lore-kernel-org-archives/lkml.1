Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYCAJh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYCAJh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYCAJhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 04:37:14 -0500
Received: from 187.Red-80-37-203.staticIP.rima-tde.net ([80.37.203.187]:28433
	"EHLO betty.it.uc3m.es" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750754AbYCAJhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 04:37:12 -0500
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200803010937.m219b3or011970@betty.it.uc3m.es>
Subject: Re: sysctl in 2.6.24.2 excludes unapproved files from
 /proc/sys?
X-ELM-OSV: (Our standard violations) hdr-charset=US-ASCII; no-hdr-encoding=1
In-Reply-To: <b6fcc0a0802291746y7375ba71ja0dc0beb58c4ccb1@mail.gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 1 Mar 2008 10:37:03 +0100 (CET)
CC: linux kernel <linux-kernel@vger.kernel.org>
Reply-To: ptb@inv.it.uc3m.es
X-Anonymously-To: 
X-message-flag: Had your Outlook virus, today?
 http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
X-Mailer: ELM [version 2.4ME+ PL123]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Also sprach Alexey Dobriyan:"
> 
> If I understand you correcty, the answer is drop '.ctl_name' bits from
> new sysctls and make sure common parts of tables match the ones
> in mainline.

YES! Setting .ctl_name to 0 on _every_ _single_ _item_ of my sub-hierarchy
did the trick. Thank you, thank you, thank you.

And how does it know when it gets to the end of a list held as
consecutive entries in an array now? One always used to set .ctl_name
to zero for that marker!

I'd better zero absolutely everything at array end.

Thanks again. I was looking at the documentation for configfs (it
exists!) and muttering "this is way too hard and unsuitable anyway",
and sysfs ("this is just not appropriate"). Sysctl is definitely
the right thing to do for me .. modulo that I would like some finer
control, at my choice, of over when things appear and disappear.

Peter
