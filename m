Return-Path: <linux-kernel-owner+w=401wt.eu-S1762238AbXGKKUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238AbXGKKUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbXGKKUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:20:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899AbXGKKUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:20:21 -0400
Date: Wed, 11 Jul 2007 12:19:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-ID: <20070711101958.GA10095@elte.hu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710105240.GA20914@linux.vnet.ibm.com> <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com> <20070710115319.0bdaff34.akpm@linux-foundation.org> <20070711045516.GH2927@linux.vnet.ibm.com> <20070710222942.382fc9ba.akpm@linux-foundation.org> <20070711090423.GA6758@elte.hu> <20070711022352.71604404.pj@sgi.com> <20070711100323.GA23473@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711100323.GA23473@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> The other alternative is to hook up group scheduler with user-id's 
> (again only for 2.6.23).

could you just try this and send an as simple patch as possible? This is 
actually something that non-container people would be interested in as 
well. (btw., if this goes into 2.6.23 then we cannot possibly turn it 
off in 2.6.24, so it must be sane - but per UID task groups are 
certainly sane, the only question is how to configure the per-UID weight 
after bootup. [the default after-bootup should be something along the 
lines of 'same weight for all users, a bit more for root'.]) This would 
make it possible for users to test that thing. (it would also help 
X-heavy workloads.)

	Ingo
