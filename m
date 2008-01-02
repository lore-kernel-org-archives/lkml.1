Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYABUbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYABUbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYABUay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:30:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43423 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYABUax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:30:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x86 compat_binfmt_elf, Makefile fixes (was: Re: 2.6.24-rc6-mm1)
Date: Wed, 2 Jan 2008 21:32:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <200712232344.39302.rjw@sisk.pl> <20080102200511.GA3722@elte.hu>
In-Reply-To: <20080102200511.GA3722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801022132.30994.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of January 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > Try to delete your fs/ directory in your output dir. Then I expect 
> > > the same bug to surface again.
> > 
> > It does surface indeed.
> 
> could you try the patch from Sam below - does it fix the problem? 

Well, with this patch applied the compilation reliably fails with:

No rule to make target `arch/x86/ia32/ia32_binfmt.o', needed by `arch/x86/ia32/built-in.o'.

[Do you want the .config, btw?]

Rafael
