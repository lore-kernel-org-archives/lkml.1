Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbXKXEDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbXKXEDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 23:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXKXEDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 23:03:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbXKXEDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 23:03:33 -0500
Date: Sat, 24 Nov 2007 04:03:24 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Milan Broz <mbroz@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Message-ID: <20071124040324.GM24157@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Torsten Kaiser <just.for.lkml@googlemail.com>,
	Milan Broz <mbroz@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com> <20071119075627.GB28432@elte.hu> <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com> <4741F97D.6090808@redhat.com> <64bb37e0711231442y7603366aib9642eab97e5be6b@mail.gmail.com> <20071124034907.GD22843@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071124034907.GD22843@agk.fab.redhat.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also io->pending may need better protection - atomic, but missing memory
barriers?  (May be getting away without sometimes due to side-effects of
other function calls, but needs doing properly.)

[BTW Other device-mapper atomic_t usage also needs reviewing.]

Alasdair
-- 
agk@redhat.com
