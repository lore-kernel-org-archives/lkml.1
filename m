Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbXCMAjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbXCMAjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 20:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXCMAjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 20:39:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:52816 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbXCMAja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 20:39:30 -0400
From: Andreas Schwab <schwab@suse.de>
To: Giuliano Pochini <pochini@denise.shiny.it>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: /sys/devices/system/cpu/cpuX/online are missing
References: <20070311222652.5ea40da1.pochini@shiny.it>
	<20070312085826.GA9985@osiris.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0703122337350.25919@denise.shiny.it>
X-Yow: Everybody gets free BORSCHT!
Date: Tue, 13 Mar 2007 01:39:25 +0100
In-Reply-To: <Pine.LNX.4.64.0703122337350.25919@denise.shiny.it> (Giuliano
	Pochini's message of "Mon, 12 Mar 2007 23:48:21 +0100 (CET)")
Message-ID: <je6496asea.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Giuliano Pochini <pochini@denise.shiny.it> writes:

> I had a look at arch/powerpc/kernel/smp.c but I'm not familiar at all with 
> those parts of the kernel.

See arch/powerpc/kernel/sysfs.c:topology_init.  I don't think there is
anything to do here.  You probably don't have CONFIG_HOTPLUG_CPU enabled.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
