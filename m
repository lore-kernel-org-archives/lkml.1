Return-Path: <linux-kernel-owner+w=401wt.eu-S1762268AbYCFKpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762268AbYCFKpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbYCFKpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:45:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48343 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461AbYCFKpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:45:00 -0500
Date: Thu, 6 Mar 2008 11:44:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wedgwood <cw@f00f.org>
Cc: Pawel Plociennik <paplociennik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306104448.GG13391@elte.hu>
References: <200803060001.38432.paplociennik@gmail.com> <20080306103422.GA5511@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306103422.GA5511@puku.stupidest.org>
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


* Chris Wedgwood <cw@f00f.org> wrote:

> On Thu, Mar 06, 2008 at 12:01:38AM -0500, Pawel Plociennik wrote:
> 
> > I have sent a *last* version of a patch which it has added a new 
> > kernel parameter chroot= It were discusioned a *long time* on a lkml 
> > so I hope that it will has been applied.
> 
> That patch is mangled and you can do this with an initrd...

we can/could do many other boot options via an initrd too. But given an 
existing initrd (which might have come from the distro, etc.) i prefer 
adding boot options instead of modifying the initrd.

	Ingo
