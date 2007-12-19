Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbXLSPKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbXLSPKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbXLSPJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:09:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbXLSPJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:09:55 -0500
Date: Wed, 19 Dec 2007 16:09:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernels
	prior to tsc sync cleanup
Message-ID: <20071219150938.GA15267@elte.hu>
References: <47680173.6060606@qumranet.com> <20071218221930.GA26109@elte.hu> <4768BB43.1000609@qumranet.com> <4768FE27.7020305@qumranet.com> <47690304.1090903@qumranet.com> <20071219140624.GF21282@elte.hu> <47693054.20501@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47693054.20501@qumranet.com>
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


try this test perhaps in an SMP guest:

 http://people.redhat.com/mingo/time-warp-test/time-warp-test.c

you can ignore TSC warps - but no GTOD or CLOCK warps should occur.

	Ingo
