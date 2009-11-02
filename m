Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZKBTkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZKBTkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbZKBTkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:40:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34191 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701AbZKBTkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:40:40 -0500
Date: Mon, 2 Nov 2009 20:40:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       laijs@cn.fujitsu.com, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra
	check
Message-ID: <20091102194037.GA19306@elte.hu>
References: <b8bf37780911020926rd5e40b1h957c803f7bb21196@mail.gmail.com> <20091102181944.GA4880@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102181944.GA4880@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> I'm not sure this change is necessary, the only impact is a small 
> reduce of binary code. Well, why not.

Small reductions in size are nice too. They counter-act small increases 
in kernel size. (which are way more common unfortunately)

	Ingo
