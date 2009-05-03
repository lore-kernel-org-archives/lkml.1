Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZECJyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZECJyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbZECJxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:53:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:40400 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbZECJxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:53:47 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Anssi Kolehmainen" <anssi@aketzu.net>
Date: Sun, 3 May 2009 19:53:30 +1000 (EST)
Message-ID: <180f4e6e9dca4be3527469e106c6e6b4.squirrel@neil.brown.name>
In-Reply-To: <20090503074429.GA3436@aketzu.net>
References: <20090503074429.GA3436@aketzu.net>
Subject: Re: BUG: Bad page state in process md1_resync  pfn:50ab4
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 3, 2009 5:44 pm, Anssi Kolehmainen wrote:
> Last night one server died apparently while doing resync of 1.5Tb md
> raid1 array. Syslog [1] contained messages about BUG: Bad page state but
> something else killed the system. Too bad the start of the stack trace
> didn't fit in the monitor [2] so I don't know the exact cause for the
> final freeze.
>
> The machine is rather old desktop PC serving disks over NFS and Samba.
> Apart from failing Seagate drives everything has worked fine for few
> weeks and this is the first time this occured. Any thoughts of the BUG
> or is there anything else you would like to know?

This a known problem  it is fixed in 2.6.29.2 released just recently.

My apologies that it wasn't caught before .29 was released.

NeilBrown

