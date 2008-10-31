Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYJaWCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYJaWCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 18:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbYJaWCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 18:02:36 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37921 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434AbYJaWCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 18:02:35 -0400
Subject: Re: [PATCH] fix compile breakage caused by x86: add
	->pre_time_init to x86_quirks
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <20081030222308.GM30303@elte.hu>
References: <1225400831.19324.21.camel@localhost.localdomain>
	 <20081030222308.GM30303@elte.hu>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 12:47:26 -0500
Message-Id: <1225475246.3264.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 23:23 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > >From da69eaed98248bf4b29e94d62a4e01a5c3758669 Mon Sep 17 00:00:00 2001
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date: Wed, 29 Oct 2008 13:14:29 -0500
> > Subject: [VOYAGER] x86: add voyager pre_time_init_hook
> > 
> > This was introduced by:
> > 
> > Author: Yinghai Lu <yhlu.kernel@gmail.com>
> > Date:   Sat Jul 19 18:02:26 2008 -0700
> > 
> >     x86: add ->pre_time_init to x86_quirks
> > 
> > In theory, voyager could also make use of the x86_quirks hooks but,
> > unfortunately, they're not set up correctly for that to happen yet.
> 
> okay, so how about setting them up that way instead? That way we win 
> twice: it becomes a tiny bit easier to add Voyager support to the 
> generic platform code, and we also fix the build breakage.

Sure, it should be possible ... but reworking the current quirk
infrastructure would definitely be an enhancement, whereas this is a
compile fix for 2.6.28-rc

James


