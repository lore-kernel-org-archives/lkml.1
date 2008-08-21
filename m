Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYHUMN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYHUMN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYHUMNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:13:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47099 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbYHUMNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:13:15 -0400
Date: Thu, 21 Aug 2008 14:13:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0 of 4] Xen spinlock updates and performance
	measurements
Message-ID: <20080821121300.GA26397@elte.hu>
References: <patchbomb.1219276937@localhost> <20080821115304.GF30667@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080821115304.GF30667@elte.hu>
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


-tip testing found this build failure:

 arch/x86/xen/spinlock.c: In function ‘spin_time_start’:
 arch/x86/xen/spinlock.c:60: error: implicit declaration of function ‘xen_clocksource_read’

i've excluded these new commits for now from tip/master - could you 
please send a delta fix against tip/x86/xen?

	Ingo
