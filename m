Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYCDRmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYCDRmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYCDRmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:42:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58796 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYCDRl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:41:59 -0500
Date: Tue, 4 Mar 2008 18:43:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080304174315.GB27332@one.firstfloor.org>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com> <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080303231033.GB15255@one.firstfloor.org> <20080304040048.GA31562@codemonkey.org.uk> <20080304071423.0e6b71c1@mjolnir.drzeus.cx> <20080304181924.70aaf8c1@mjolnir.drzeus.cx> <20080304172918.GA27332@one.firstfloor.org> <20080304183032.17084e39@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304183032.17084e39@mjolnir.drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And how can I tell if this handler has run? Not that it really matters I guess, as I don't think running it from the cpuidle governor is very sane.
 
After irq_enter->tick_nohz_update_jiffies() 

You might need a new callback into the idle governours for this though.

-Andi
