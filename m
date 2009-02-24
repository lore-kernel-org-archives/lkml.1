Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbZBXR5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbZBXR5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbZBXR5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:57:43 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3795 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZBXR5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:57:43 -0500
Message-ID: <49A434FD.1080308@phoenixsoftware.de>
Date: Tue, 24 Feb 2009 18:57:17 +0100
From: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [2.6.28.7] BUG: using smp_processor_id() in preemptible [00000000]
 code: pageattr-test/207
References: <49A2ECF5.80104@phoenixsoftware.de> <20090223151331.033e0bf5.akpm@linux-foundation.org> <49A343EE.20100@phoenixsoftware.de> <20090224083028.GA17355@elte.hu>
In-Reply-To: <20090224083028.GA17355@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.37 () AWL,BAYES_50,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 09:30:28 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> should be fixed by this as well:
> 
> d85cf93: x86/paravirt: make arch_flush_lazy_mmu/cpu disable preemption

Confirmed.
