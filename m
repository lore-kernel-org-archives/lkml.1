Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbZAWR4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbZAWR4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 12:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZAWR4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 12:56:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbZAWR4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 12:56:37 -0500
Date: Fri, 23 Jan 2009 18:56:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] xen: handle highmem pages correctly when shrinking a
	domain
Message-ID: <20090123175614.GA26627@elte.hu>
References: <70c0102ea4c18ecab426.1232727981@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70c0102ea4c18ecab426.1232727981@localhost.localdomain>
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


* Ian Campbell <ian.campbell@citrix.com> wrote:

> This commit causes a crash if the page being released is a highmem
> page.
> 
>   commit 1058a75f07b9bb8323fb5197be5526220f8b75cf
>   Author: Dan Magenheimer <dan.magenheimer@oracle.com>
>   Date:   Thu Jan 22 14:36:08 2009 -0800
> 
>     xen: actually release memory when shrinking domain
> 
> If a page is highmem then there is no need to unmap it.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: dan.magenheimer@oracle.com <dan.magenheimer@oracle.com>
> Cc: Xen-devel <xen-devel@lists.xensource.com>
> Cc: Stable Kernel <stable@kernel.org>
> ---
>  drivers/xen/balloon.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Applied to tip/x86/urgent, thanks Ian!

	Ingo
