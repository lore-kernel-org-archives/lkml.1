Return-Path: <linux-kernel-owner+w=401wt.eu-S1761697AbYFMHAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697AbYFMHAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYFMHAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:00:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54116 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbYFMHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:00:32 -0400
Date: Fri, 13 Jun 2008 08:59:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       sam@ravnborg.org, shai@scalex86.org
Subject: Re: [2.6.25 - stable] Fix Kconfig dependencies to prevent
	CONFIG_X86_VSMP from vanishing
Message-ID: <20080613065945.GB28810@elte.hu>
References: <20080613023348.GA6071@localdomain> <20080613044858.GC5427@elte.hu> <20080613051718.GB6071@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613051718.GB6071@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0016]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> If 823c248e7cc75b4f22da914b01f8e5433cff197e can be applied completely then
> great!  Here's the commit slightly re-diffed for 2.6.25
> 
> Thanks,
> Kiran
> 
> ---
> 
> From: Roman Zippel <zippel@linux-m68k.org>
> Mainline commit: 823c248e7cc75b4f22da914b01f8e5433cff197e
> 
>     x86: fix recursive dependencies
> 
>     The proper dependency check uncovered a few dependency problems,
>     the sub-architecture used a mixture of selects and depends on SMP
>     and PCI dependency was messed up.
> 
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

btw., you can keep signoffs in such cases, i.e. make it:

    Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

	Ingo
