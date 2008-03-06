Return-Path: <linux-kernel-owner+w=401wt.eu-S1764900AbYCFK5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764900AbYCFK5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763685AbYCFK4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:56:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40126 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763692AbYCFKzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:55:53 -0500
Date: Thu, 6 Mar 2008 11:55:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de
Subject: Re: [PATCH 1/1] export native versions of machine_ops functions
Message-ID: <20080306105500.GK13391@elte.hu>
References: <1204739040-18422-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204739040-18422-1-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0368]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber Costa <gcosta@redhat.com> wrote:

> People overriding machine_ops provided functions may want to call the 
> native version after its pre-processing. It already happens for the 
> smp_ops functions, so I don't see a reason for avoiding it here.

i'd like to do this only if there are actual users - otherwise we'll get 
a trickle of "make needlessly global functions static" patches a few 
weeks later ;-)

	Ingo
