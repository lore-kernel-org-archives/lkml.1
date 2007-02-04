Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXBDSSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXBDSSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 13:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXBDSSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 13:18:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:9359 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXBDSSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 13:18:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Qnk/DV/H+W6Gk/t3ic+gkVhiEiQbDQcjKiOaqzmDEj/7R7Vvdo0RNFJ0GqEIFqfprS3sgtUjBKDwlLWufwGOf935HDR4PtclKMYHsdX5LMYw3+yTQOnBXCkLZaHGAlWDlE7/QtUN9hJzdvXGE0RqOXKMVIQZNe/kT1ElZtZ/d0A=
Subject: Re: 2.6.20-rc7: known regressions
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
In-Reply-To: <Pine.LNX.4.64.0702040928330.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	 <200702031058.13830.ak@suse.de> <1170499668.31373.35.camel@funkylaptop>
	 <200702031151.17220.ak@suse.de> <1170594788.5217.4.camel@funkylaptop>
	 <Pine.LNX.4.64.0702040928330.8424@woody.linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Sun, 04 Feb 2007 19:18:17 +0100
Message-Id: <1170613097.5217.13.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 04 février 2007 à 09:34 -0800, Linus Torvalds a écrit :
> 
> On Sun, 4 Feb 2007, Frédéric Riss wrote:
> > 
> > New patch:
> 
> I didn't get how this would fix the ia64 issues? I thought ia64 needed 
> the standard calling convention?

I think Andi said that adding asmlinkage on the function pointers
shouldn't harm ia64. If you prefer wrapper functions, one of the patches
I sent ( http://lkml.org/lkml/2007/1/30/309 ) did that, but the casting
it uses looks clumsy.

Fred.


