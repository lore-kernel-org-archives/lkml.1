Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYJGXjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYJGXjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYJGXjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:39:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41396 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbYJGXjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:39:21 -0400
Date: Wed, 8 Oct 2008 01:45:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, tglx@linutronix.de,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: NMI watchdog setup_lapic_nmi_watchdog() problem
Message-ID: <20081007234529.GC7971@one.firstfloor.org>
References: <7c86c4470810070845w1346107cx211148c52fd03b68@mail.gmail.com> <20081007132158.009669d2.akpm@linux-foundation.org> <7c86c4470810071410u205fe7c4n43f9dbb76e49812e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470810071410u205fe7c4n43f9dbb76e49812e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you remove the 'cheap hack', disabling/enabling works. That's why
> I'd like to better
> understand was is going on with suspend/resume.

The hack was done because there wasn't an available CPU global enable flag
for the nmi watchdog. So resume would possible reenable it unnecessarily 
If there was one it could just check that.

-Andi

-- 
ak@linux.intel.com
