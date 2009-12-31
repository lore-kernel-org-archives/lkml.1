Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbZLaO70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbZLaO70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 09:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZLaO7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 09:59:25 -0500
Received: from khc.piap.pl ([195.187.100.11]:58077 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbZLaO7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 09:59:25 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: gentoo-user@lists.gentoo.org, Dirk Heinrichs <dirk.heinrichs@online.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-user] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org>
	<200912301208.54359.dirk.heinrichs@online.de>
	<4B3B38F2.6090006@asyr.hopto.org>
Date: Thu, 31 Dec 2009 15:59:22 +0100
In-Reply-To: <4B3B38F2.6090006@asyr.hopto.org> (thanasis@asyr.hopto.org's
	message of "Wed, 30 Dec 2009 13:26:42 +0200")
Message-ID: <m3fx6r8a0l.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> writes:

> I thought CONFIG_HIGHMEM4G had to do with more than 4GB of RAM.
> Now I can see that the associated help says it is for an amount between
> 1 and 4GB.

Depends on the "split" used. With 2 GB : 2 GB you can have all-lowmem
1.5 GB RAM, without CONFIG_HIGHMEM*. 2 GB of per-process address space
is usually not a problem.

x86-64 removes such limits.
-- 
Krzysztof Halasa
