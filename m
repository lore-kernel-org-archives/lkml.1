Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbZD0PlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbZD0PlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZD0PlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:41:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbZD0PlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:41:02 -0400
Subject: Re: kms in defconfig
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090427083935.GA20941@elte.hu>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
	 <20090427083935.GA20941@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Apr 2009 17:40:43 +0200
Message-Id: <1240846843.7620.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 10:39 +0200, Ingo Molnar wrote:
> * Dave Airlie <airlied@gmail.com> wrote:
> 
> > Hi guys,
> > 
> > I just noticed CONFIG_DRM_I915_KMS is enabled for x86-64.
> > 
> > This should never be the case, as anyone who built defconfig 
> > kernels before, will now get KMS enabled when really they need to 
> > have done userspace upgrades.
> 
> I've yet to see such a bugreport.

Whenever I accidentally enable KMS I get a dead X (happens way more
often that I'd like to), I blame this on the ubuntu Xorg packages, but
can't be arsed to fix it myself -- hopefully the kinky koala will fix
stuff, but who knows.
