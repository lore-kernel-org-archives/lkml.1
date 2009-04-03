Return-Path: <linux-kernel-owner+w=401wt.eu-S1765315AbZDCRiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765315AbZDCRiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934829AbZDCRhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:37:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40742 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934300AbZDCRhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:37:42 -0400
Date: Fri, 3 Apr 2009 19:36:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen for 2.6.30 #2
Message-ID: <20090403173623.GB6295@elte.hu>
References: <49D1209A.9000800@goop.org> <49D25A42.7060300@goop.org> <20090331185541.GA17807@elte.hu> <49D2713D.6090401@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D2713D.6090401@goop.org>
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

>> You know our stance which is very simple: dont put in Xen-only 
>> hooks that slow down native, and get rid of the existing Xen-only 
>> hooks.
>
> Yes, I understand that.  Unlike the pvops stuff, the dom0 changes 
> are largely all init-time and setup, and so have no performance 
> impact.

Yes, but once dom0 goes in your incentive to fix the native kernel 
performance drain we accumulated along the years of paravirt layers 
will be strongly weakened, right? :)

	Ingo
