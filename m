Return-Path: <linux-kernel-owner+w=401wt.eu-S932175Ab0AVBmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab0AVBmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156Ab0AVBmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:42:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51885 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0AVBmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:42:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Cc: kosaki.motohiro@jp.fujitsu.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100122100155.6C03.A69D9226@jp.fujitsu.com>
References: <201001212121.50272.rjw@sisk.pl> <20100122100155.6C03.A69D9226@jp.fujitsu.com>
Message-Id: <20100122103830.6C09.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 22 Jan 2010 10:42:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Probably we have multiple option. but I don't think GFP_NOIO is good
> > > option. It assume the system have lots non-dirty cache memory and it isn't
> > > guranteed.
> > 
> > Basically nothing is guaranteed in this case.  However, does it actually make
> > things _worse_?  
> 
> Hmm..
> Do you mean we don't need to prevent accidental suspend failure?
> Perhaps, I did misunderstand your intention. If you think your patch solve
> this this issue, I still disagree. but If you think your patch mitigate
> the pain of this issue, I agree it. I don't have any reason to oppose your
> first patch.

One question. Have anyone tested Rafael's $subject patch? 
Please post test result. if the issue disapper by the patch, we can
suppose the slowness is caused by i/o layer.



