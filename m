Return-Path: <linux-kernel-owner+w=401wt.eu-S1759736AbYGOMoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736AbYGOMoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbYGOMoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:44:24 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2971 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309AbYGOMoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:44:24 -0400
Date: Tue, 15 Jul 2008 15:44:06 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc7: BUG at kernel/power/snapshot.c:493
Message-ID: <20080715124406.GE2946@deprecation.cyrius.com>
References: <1214584985.22228.15.camel@localhost> <200807092300.59678.rjw@sisk.pl> <20080711153815.GA7109@deprecation.cyrius.com> <200807112105.20917.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807112105.20917.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [2008-07-11 21:05]:
> If you have the user space resume utility in your initrd, please try
> to disable or remove it.  I'd like to verify if it is responsible
> for this message.

I haven't had a chance to try this yet.  However, I made a new
observation in the meantime: when I suspend my system with 2.6.25 and
resume it with 2.6.25, I get the problem.  But if I suspend my system
with 2.6.25 and then resume it with 2.6.26-rc9 it resumes just fine.
Suspending with 2.6.26-rc9 and resuming with 2.6.26-rc9 also works
fine.

-- 
Martin Michlmayr
http://www.cyrius.com/
