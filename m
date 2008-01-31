Return-Path: <linux-kernel-owner+w=401wt.eu-S934663AbYAaRu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663AbYAaRu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764701AbYAaRuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:50:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51698 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763446AbYAaRuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:50:14 -0500
Date: Thu, 31 Jan 2008 18:49:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86.git: wants to build as ia64
Message-ID: <20080131174947.GA7956@elte.hu>
References: <47A20750.8000702@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A20750.8000702@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0029]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Something in current x86.git is making my kernel build as ia64.  I 
> don't see any obvious change which might be the cause.

fun bug of the day: a toplevel Makefile cross-build-ism escaped out into 
the mm branch. Should be fixed in head f6e096d93259a3a. (which should be 
available on git.kernel.org in a minute or so)

	Ingo
