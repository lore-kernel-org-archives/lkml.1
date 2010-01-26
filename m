Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877Ab0AZNS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0AZNS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859Ab0AZNS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:18:27 -0500
Received: from mga06.intel.com ([134.134.136.21]:58204 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753835Ab0AZNS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:18:26 -0500
Message-Id: <89khjo$egh4fr@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,346,1262592000"; 
   d="scan'208";a="487100923"
Date: Tue, 26 Jan 2010 13:18:16 +0000
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
Cc: Roman Jarosz <kedgedev@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       A Rojas <nqn1976list@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
References: <20100126141055.5AAD.A69D9226@jp.fujitsu.com> <op.u64t84zuasvm2a@kedge> <20100126183412.6AC9.A69D9226@jp.fujitsu.com> <89k77n$mrr1hi@fmsmga001.fm.intel.com> <2f11576a1001260503o5f987512n3c39ae1c3caa43f3@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <2f11576a1001260503o5f987512n3c39ae1c3caa43f3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 22:03:06 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> Please consider to revert such commit at once. Lots people reported
> the same issue.
> I really hope to stop bug report storm.

Your CC did not reference the problem that you were discussing, nor that
it is even easier to trigger an OOM without the shrinker. Memory
exhaustion due to the excess usage of surfaces from userspace is not a new
issuer. So what is the problem you have encountered and how does running
the OOM killer earlier fix the issue of triggering the OOM killer?

-- 
Chris Wilson, Intel Open Source Technology Centre
