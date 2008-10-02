Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYJBTvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYJBTvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYJBTu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:50:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59659 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbYJBTu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:50:57 -0400
Date: Thu, 2 Oct 2008 21:50:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [patch x86/core] x86: allow number of additional hotplug CPUs
	to be set at compile time, V2
Message-ID: <20081002195048.GA12109@elte.hu>
References: <20081001191945.4182d0be@redhat.com> <20081002081231.GC17695@elte.hu> <20081002153007.2e031232@redhat.com> <20081002194215.GA8078@elte.hu> <48E525A1.5080509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E525A1.5080509@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>>>
>>> The default number of additional CPU IDs for hotplugging is 
>>> determined by asking ACPI or mptables how many "disabled" CPUs there 
>>> are in the system, but many systems get this wrong so that e.g. a 
>>> uniprocessor machine gets an extra CPU allocated and never switches 
>>> to single CPU mode.
>>>
>>> And sometimes CPU hotplugging is enabled only for suspend/hibernate  
>>> anyway, so the additional CPU IDs are not wanted. Allow the number to 
>>> be set to zero at compile time.
>>>
>
> Wouldn't this be better to have a runtime option?

yeah - and we already have the additional_cpus=x boot option, but a boot 
option is not generally useful to a distribution.

	Ingo
