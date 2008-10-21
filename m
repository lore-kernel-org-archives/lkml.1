Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYJUJuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYJUJuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYJUJuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:50:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52085 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYJUJuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:50:04 -0400
Date: Tue, 21 Oct 2008 11:50:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alok Kataria <akataria@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
Message-ID: <20081021095002.GA5880@atrey.karlin.mff.cuni.cz>
References: <1224552902.2640.88.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224552902.2640.88.camel@alok-dev1>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> This patch set makes some changes to the TSC code, so that it is always
> used as the default clocksource when running under VMware.
> The first 2 patches do the ground work of adding code to detect if we
> are running under VMware.
> The third patch adds a tsc_reliable flag which tells us that TSC is
> reliable on this system, so that we can skip some tests which can
> potentially mark TSC as unstable. Details under individual patch
> headers. 

How do you _know_ TSC is stable under VMWare? AFAICT, accesses to TSC
are not virtualized and system VMWare runs on may still use frequency
scaling, no?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
