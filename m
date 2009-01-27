Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZA0Rz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZA0Rz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbZA0RzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:55:16 -0500
Received: from mailhost-s0-p2.nerim-networks.com ([195.5.209.67]:60329 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753934AbZA0RzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:55:15 -0500
Date: Tue, 27 Jan 2009 18:53:52 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090127175352.GB3116@localhost.localdomain>
References: <20090120162537.GA2344@localhost.localdomain> <20090127160536.GA2241@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127160536.GA2241@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Testing 2.6.29-rc2-git1, I notice something which doesn't happen with
> > 2.6.28.1 on the same machine with the same config (minus new config
> > entries for 2.6.29) : when the machine is idle, the load average
> > reported by top is not 0.00 (it is with 2.6.28.1) but between 0.30 and
> > 0.80 and either ksoftirqd/0 or ksoftirqd/1 is listed as number one in
> > top output, with a few % of CPU. The machine seems to work fine but
> > I think something is still wrong.

> The problem is still present in 2.6.29-rc2-git3 on this P4 machine,
> but I do not see it on a Centrino laptop.

Sorry for this half-true claim, after double check, the problem is
*also* present on the Centrino laptop.

-- 
Damien Wyart
