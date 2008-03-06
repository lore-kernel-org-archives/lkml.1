Return-Path: <linux-kernel-owner+w=401wt.eu-S1764648AbYCFMN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764648AbYCFMN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYCFMNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:13:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40962 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbYCFMNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:13:48 -0500
Date: Thu, 6 Mar 2008 13:13:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <glommer@gmail.com>
Cc: Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 1/1] export native versions of machine_ops functions
Message-ID: <20080306121313.GA19613@elte.hu>
References: <1204739040-18422-1-git-send-email-gcosta@redhat.com> <20080306105500.GK13391@elte.hu> <5d6222a80803060349g69f570f3j9eaab980d7c58da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80803060349g69f570f3j9eaab980d7c58da@mail.gmail.com>
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


* Glauber Costa <glommer@gmail.com> wrote:

> >  i'd like to do this only if there are actual users - otherwise 
> >  we'll get a trickle of "make needlessly global functions static" 
> >  patches a few weeks later ;-)
> 
> KVM is a user for that. Because it registers a memory area in which 
> the host will be continually writting to (the clock), when it 
> shutdown, the host have no way to know it has to stop. If you're 
> really shutting down, there's no problem. But if you're kexecing, for 
> example, the host will keep writting to a random memory area after the 
> new kernel installs.

i mean, i agree in general - but KVM is not a user of any of those 
currently static functions. So i've applied your patch but lets make 
sure those functions really get used :)

	Ingo
