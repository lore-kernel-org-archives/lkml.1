Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYGXK3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYGXK3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYGXK3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:29:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYGXK3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:29:11 -0400
Date: Thu, 24 Jul 2008 12:28:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: call early_cpu_init at the same point
Message-ID: <20080724102856.GB28817@elte.hu>
References: <488520A2.1080701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488520A2.1080701@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Call early_cpu_init() at the same (early) point in setup_arch(). The 
> x86_64 code was calling it relatively late, after when other arch code 
> need to do cpu-related setup which depends on it.

applied to tip/x86/urgent, thanks Jeremy.

	Ingo
