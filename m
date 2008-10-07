Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbYJGPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbYJGPsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYJGPsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:48:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54806 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYJGPsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:48:00 -0400
Date: Tue, 7 Oct 2008 17:54:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11569] Don't complain about disabled irqs when the system has paniced
Message-ID: <20081007155407.GO20740@one.firstfloor.org>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.qTH.6475IB@wind> <20081006060238.GB3180@one.firstfloor.org> <200810080244.06958.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810080244.06958.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why doesn't it use something like nmi_shootdown_cpus on panic rather than

There are unfortunately a couple of BIOS around that hang randomly when
NMIs are used (e.g. common problem on ThinkPads). That broke the neck
of the NMI watchdog too.

But yes if we had some way to distingush these broken systems from
sane ones NMI would be the way to go in panic.

-Andi
-- 
ak@linux.intel.com
