Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbZDHOWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbZDHOWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZDHOVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:21:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZDHOVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:21:50 -0400
Date: Wed, 8 Apr 2009 16:21:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH V3 0/7] swiotlb: changes for powerpc/highmem
Message-ID: <20090408142131.GE12931@elte.hu>
References: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kumar Gala <galak@kernel.crashing.org> wrote:

> This is a repost of Becky's patches from the v2 version.  The only 
> change is to incorporate feedback on "Create swiotlb_unmap_single" 
> an to add Ack by FUJITA Tomonori for patches that have been 
> reviewed.

thanks - picked them up.

This commit:

  dd6b02f: swiotlb: map_page fix for highmem systems

should perhaps go into an urgent track for .30 too? Jeremy, does Xen 
already make use of the swiotlb? (it does not right now AFAICS but 
.30 mergs of Xen might, so it would be good for them to have this 
fix.)

	Ingo
