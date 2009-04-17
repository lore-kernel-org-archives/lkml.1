Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbZDQOmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbZDQOmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbZDQOmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:42:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38541 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbZDQOmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:42:15 -0400
Date: Fri, 17 Apr 2009 16:41:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Weidong Han <weidong.han@intel.com>
Cc: allen.m.kay@intel.com, fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 0/5] fix bugs of x2apic/intr-remap
Message-ID: <20090417144152.GA11772@elte.hu>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com> <20090417143033.GF23493@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090417143033.GF23493@elte.hu>
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


Note, there's a new compiler warning caused by your patches:

  arch/x86/kernel/apic/io_apic.c:2543: warning: ‘eoi_ioapic_irq’ defined but not used

most likely by:

  631dd75: x86, intr-remap: fix ack for interrupt remapping

	Ingo
