Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbZKJWUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbZKJWUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbZKJWUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:20:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58231 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbZKJWUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:20:48 -0500
Date: Tue, 10 Nov 2009 23:20:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Willy Tarreau <w@1wt.eu>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110222031.GA22911@elte.hu>
References: <20091110172454.3c4481f2@lxorguk.ukuu.org.uk>
 <4AF9B5AB.5010800@zytor.com>
 <4AF9C3EF.6000705@redhat.com>
 <4AF9C6AB.8080006@zytor.com>
 <20091110201602.GA26633@1wt.eu>
 <20091110205445.GB1407@ucw.cz>
 <20091110211259.GD26633@1wt.eu>
 <4AF9D8E2.7050205@zytor.com>
 <20091110220652.GE26633@1wt.eu>
 <4AF9E61B.5090407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9E61B.5090407@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> *THIS* is the kind of complexity that makes me think that having a 
> single source for all interpretation done in the kernel is the 
> preferred option.

Definitely agreed ... The NX code is quite a maze right now, so changes 
to it should come generously laced with cleanups.

	Ingo
