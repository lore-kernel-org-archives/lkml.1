Return-Path: <linux-kernel-owner+w=401wt.eu-S964792AbXDLJjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbXDLJjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965494AbXDLJjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:39:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45875 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964792AbXDLJjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:39:44 -0400
Date: Thu, 12 Apr 2007 10:42:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pedro <linux_user@izecksohn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Message-ID: <20070412104256.132cd21c@the-village.bc.nu>
In-Reply-To: <200704120219.03171.linux_user@izecksohn.com>
References: <200704110223.31291.linux_user@izecksohn.com>
	<200704111927.00609.linux_user@izecksohn.com>
	<20070411233921.7a5c3cff@the-village.bc.nu>
	<200704120219.03171.linux_user@izecksohn.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 0 - try and spot obviously dumb allocations
> > 1 - anything goes
> > 2 - strictly control resource commit
> 
>   I deduce that a fail-safe application must scanf overcommit_memory, warn 
> the user and waitpid.

If you are building a fail safe system you need to look a bit beyond out
of memory handling settings - power supplies, failover, fault tolerance
requirements, error detection (eg ECC ram), raid arrays over
non-electrically conductive links etc.

Alan
