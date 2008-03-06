Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbYCFLhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbYCFLhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYCFLhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:37:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbYCFLhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:37:42 -0500
Date: Thu, 6 Mar 2008 12:37:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wedgwood <cw@f00f.org>
Cc: Pawel Plociennik <paplociennik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306113729.GA18403@elte.hu>
References: <200803060001.38432.paplociennik@gmail.com> <20080306103422.GA5511@puku.stupidest.org> <20080306104448.GG13391@elte.hu> <20080306112212.GA9261@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306112212.GA9261@puku.stupidest.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wedgwood <cw@f00f.org> wrote:

> > But given an existing initrd (which might have come from the distro, 
> > etc.) i prefer adding boot options instead of modifying the initrd.
> 
> I assume this is so you have have /distro1 /distro2 and use your boot
> option to (help) select which one you boot into?

while i have no personal use for chroot=, i generally test distros that 
way, yes - and i try to keep them as unmodified as possible.

"Use the initrd as an extended boot commandline" is a poor answer IMO. 

_Everything_ we do on the boot commandline that affects user-space can 
be done in an initrd in theory - but still we have hundreds of boot 
options.

	Ingo
