Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYAHV3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYAHV3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYAHV31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:29:27 -0500
Received: from waste.org ([66.93.16.53]:43132 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbYAHV30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:29:26 -0500
Subject: Re: [PATCH] i386 : Make arch/x86/kernel/acpi/wakeup_32.S use a
	separate text section
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>, pavel@suse.cz
In-Reply-To: <20080105151134.GB9595@elte.hu>
References: <20080103210426.35543645.dada1@cosmosbay.com>
	 <20080105151134.GB9595@elte.hu>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 15:27:42 -0600
Message-Id: <1199827662.32604.4.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-05 at 16:11 +0100, Ingo Molnar wrote:
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > # size vmlinux.before vmlinux.after
> >    text    data     bss     dec     hex filename
> > 4619942  422838  458752 5501532  53f25c vmlinux.before
> > 4610534  422838  458752 5492124  53cd9c vmlinux.after
> > 
> > This saves 9408 bytes
> 
> that's nice! Applied it to x86.git. I'm wondering, do we have other such 
> cases? page alignment requirements are quite often for various CPU data 
> structures.

They slip in from time to time, it would be nice to automate checking
for them.

-- 
Mathematics is the supreme nostalgia of our time.

