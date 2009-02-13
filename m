Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbZBMI0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbZBMI0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 03:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZBMI0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 03:26:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbZBMI0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 03:26:24 -0500
Date: Fri, 13 Feb 2009 09:25:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org
Subject: Re: [PATCH -next] x86_32: fix printk formats
Message-ID: <20090213082556.GB4606@elte.hu>
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au> <49946DB8.9030801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49946DB8.9030801@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings and also change 2 %ld to %lu for unsigned long
> variables.
> 
> arch/x86/mm/init_32.c:727: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> arch/x86/mm/init_32.c:735: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  arch/x86/mm/init_32.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Already fixed in the x86 tree, but thanks.

	Ingo
