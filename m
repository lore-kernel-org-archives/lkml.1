Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZIVOc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZIVOc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZIVOc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:32:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57956 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZIVOc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:32:27 -0400
Date: Tue, 22 Sep 2009 16:32:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
Message-ID: <20090922143223.GA31702@elte.hu>
References: <4AB3CDEC.5050902@zytor.com> <1253342422-13811-1-git-send-email-avi@redhat.com> <4AB8980D.5070803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB8980D.5070803@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 09/19/2009 09:40 AM, Avi Kivity wrote:
>> Add a general per-cpu notifier that is called whenever the kernel is
>> about to return to userspace.  The notifier uses a thread_info flag
>> and existing checks, so there is no impact on user return or context
>> switch fast paths.
>>    
>
> Ingo/Peter?

Would be nice to convert some existing open-coded return-to-user-space 
logic to this facility. One such candidate would be lockdep_sys_exit?

	Ingo
