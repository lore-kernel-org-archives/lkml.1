Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYC0INt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYC0INt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbYC0INe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:13:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53793 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820AbYC0INd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:13:33 -0400
Date: Thu, 27 Mar 2008 09:13:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [x86] Stricter check in follow_huge_addr()
Message-ID: <20080327081318.GA15626@elte.hu>
References: <Pine.LNX.4.64.0803262101060.2683@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803262101060.2683@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1692]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Subject: Compound Pages: Stricter check in follow_huge_addr
> 
> The first page of the compound page is determined in 
> follow_huge_addr() but then PageCompound() only checks if the page is 
> part of a compound page. PageHead() allows checking if this is indeed 
> the first page of the compound.

thanks Christoph, applied.

btw., what type of real-life problem does this address? Did this trigger 
somewhere? (if yes, do you have any URLs i could put into the 
changelog?)

	Ingo
