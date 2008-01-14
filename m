Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYANIgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYANIgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYANIgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:36:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39130 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbYANIgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:36:00 -0500
Date: Mon, 14 Jan 2008 09:35:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, ebiederm@xmission.com,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART early v2
Message-ID: <20080114083545.GF18296@elte.hu>
References: <200801101914.47967.yinghai.lu@sun.com> <200801102354.46472.yinghai.lu@sun.com> <20080111081446.GA6234@elte.hu> <200801120207.19981.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801120207.19981.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> please check the one against x86.git it will use fix e820 for gart.

thanks, applied.

Sidenote - there were a few checkpatch failures:

 ERROR: use tabs not spaces
 #121: FILE: arch/x86/kernel/aperture_64.c:233:
 +        return 0;$

 ERROR: use tabs not spaces
 #173: FILE: arch/x86/kernel/aperture_64.c:285:
 +                fix = 1;$

i fixed them up. (please run "scripts/checkpatch.pl your.patch" in the 
future.)

	Ingo
