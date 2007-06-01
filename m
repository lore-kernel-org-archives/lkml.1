Return-Path: <linux-kernel-owner+w=401wt.eu-S1764115AbXFAURw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764115AbXFAURw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762382AbXFAURq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:17:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:44798 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762312AbXFAURp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:17:45 -0400
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
	<200706011210.15808.jbarnes@virtuousgeek.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Jun 2007 23:14:17 +0200
In-Reply-To: <200706011210.15808.jbarnes@virtuousgeek.org>
Message-ID: <p73k5unbcnq.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> (or we get proper PAT support, which I think would make this problem 
> go away as well).

No it won't. If the basic MTRRs for memory are wrong just having PAT support
in drivers (which already exist in a limited form already, just for
UC only) won't change anything.

-Andi
