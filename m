Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYE0CO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYE0CO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 22:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYE0COS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 22:14:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50449 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYE0COR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 22:14:17 -0400
Date: Mon, 26 May 2008 19:05:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Machek <pavel@suse.cz>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on
 PRIMEQUEST
Message-ID: <20080526190553.1d37e17d@infradead.org>
In-Reply-To: <20080527101302.4bd49e6c.kamezawa.hiroyu@jp.fujitsu.com>
References: <4816F9B9.3090609@jp.fujitsu.com>
	<4836660B.3080406@jp.fujitsu.com>
	<483667A4.9000606@jp.fujitsu.com>
	<20080525114308.GA5237@ucw.cz>
	<483A6D15.6030701@jp.fujitsu.com>
	<20080526080614.GA28147@elf.ucw.cz>
	<20080527101302.4bd49e6c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 10:13:02 +0900
> BTW, PrimeQuest's firmware is designed in 2.6.18 age and _heavily_
> tested under _OSI("Linux") environments. So, the acpi layer which
> returns _OSI("Linux") is valid for PrimeQuest. I don't hear a major
> firmware update for already-sold-hosts is scheduled.
> 
the problem really is that 2.6.18 isn't 2.6.25. OSI("Linux") is really
the wrong thing to do!
Not even microsoft does that.. they have very version specific OSI
strings.

Can you work with your colleges in the BIOS team to make sure that no
future BIOS will use OSI("Linux") please? If there's something they
would want to disable because of a Linux bug.. the real solution is to
fix the Linux bug!
