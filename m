Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbZJKHlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbZJKHlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 03:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZJKHlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 03:41:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42427 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbZJKHle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 03:41:34 -0400
Date: Sun, 11 Oct 2009 09:40:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Schlichter <thomas.schlichter@web.de>, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	available
Message-ID: <20091011074045.GA6555@elte.hu>
References: <200910100322.36857.thomas.schlichter@web.de> <4AD00C89.3000503@linux.intel.com> <200910101031.15620.thomas.schlichter@web.de> <4AD0ABFF.1020209@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD0ABFF.1020209@linux.intel.com>
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> Thomas Schlichter wrote:
>
>> Hmm, my CPU (VIA Nano) seems to support PAT, but Ubuntu disables this
>> feature in its kernel config. I'm using 9.04, but even 9.10 will have PAT
>> disabled:
>
> that sounds like a bad idea. But to each distro their own I suppose.
>
>
>>
>> http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-
>> karmic.git;a=blob;f=debian.master/config/config.common.ubuntu;h=a43cbabd02bfdf5412de6fea232db86aa5d3e742;hb=HEAD
>
>> So, convincing Ubuntu to enable PAT would be a workaround, but I think
>> the problem would still exist and should be fixed.
>
> I think it's time to get rid of CONFIG_PAT at all.. and just have it 
> be there. Making 10+ year old CPU features that are essential 
> functionality a config option... ... not a good idea to be honest.

Mind sending a patch that makes the configurability of PAT dependent on 
EMBEDDED or so? There's still the nopat boot option so it can still be 
configured by a distro if it wishes to.

	Ingo
