Return-Path: <linux-kernel-owner+w=401wt.eu-S1751237AbXBMKLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbXBMKLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXBMKLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:11:05 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37884 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbXBMKLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:11:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel components
References: <20070116061516.899460000@bull.net>
	<20070116063030.761795000@bull.net>
	<20070122115638.835b26a1.akpm@osdl.org> <45B61E50.6020607@bull.net>
	<m1mz3poeda.fsf@ebiederm.dsl.xmission.com> <45CC68BA.4010403@bull.net>
	<m11wkz5gd2.fsf@ebiederm.dsl.xmission.com> <45D17F8D.3020207@bull.net>
Date: Tue, 13 Feb 2007 03:10:36 -0700
In-Reply-To: <45D17F8D.3020207@bull.net> (Nadia Derbey's message of "Tue, 13
	Feb 2007 10:06:21 +0100")
Message-ID: <m14ppqtlk3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey <Nadia.Derbey@bull.net> writes:

> So, should I understand from this that automatic tuning and the AKT framework
> itself would make sense, given that I find the rigth tunables it should be
> applied to?

Sort of.  The concept of things tuning themselves automatically makes
a lot of sense.

I'm not at all certain about tunables being exported just to be hidden
again.  Ideally you don't even want the fact that these things are
varying visible to the user.

So I think that if you can find a good example that cannot be solved
better another way, you can build a case for your framework.
Currently I am doubt you can find such a case.

> Actually, dont' know if you had the opportunity to read all the patches, but
> there are 2 other tunables AKT is proposed to be applied to:
> . max_threads, the tunable limit on nr_threads
> . max_files, the tunable limit on nr_files

At a quick glance max_threads and max_files appear even more to be
DOS limits and not tunables and even less applicable to needing any
tuning at all.  My gut feel is at worst these values may need a little
better boot time defaults but otherwise they the should be good.

Eric
