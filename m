Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbYCFK0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbYCFK0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbYCFKZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:25:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38999 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551AbYCFKZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:25:55 -0500
Date: Thu, 6 Mar 2008 11:25:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH #upstream-fixes 1/2] libata: allow LLDs w/o any reset
	method
Message-ID: <20080306102532.GD13391@elte.hu>
References: <47CF6E7E.6090201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CF6E7E.6090201@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <htejun@gmail.com> wrote:

> Some old SFF controllers don't have any way to reset the channel. 
> Currently, this isn't supported and libata EH causes an oops.  Allow 
> LLDs w/o any reset method and just assume ATA class in such cases.

just to make sure, this is a must-have for 2.6.25 - it causes a boot 
regression on one of my boxes.

	Ingo
