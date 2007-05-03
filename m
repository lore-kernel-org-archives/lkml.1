Return-Path: <linux-kernel-owner+w=401wt.eu-S1767487AbXECX6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767487AbXECX6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 19:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767492AbXECX6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 19:58:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767487AbXECX6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 19:58:35 -0400
Date: Thu, 3 May 2007 16:58:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] export hrtimer_forward
Message-Id: <20070503165800.5b7cd3fd.akpm@linux-foundation.org>
In-Reply-To: <463A338A.2010909@aknet.ru>
References: <463A2296.7000804@aknet.ru>
	<1178218674.24217.14.camel@twins>
	<463A338A.2010909@aknet.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2007 23:10:02 +0400
Stas Sergeev <stsp@aknet.ru> wrote:

> Hello.
> 
> Peter Zijlstra wrote:
> >> It seems hrtimer_forward was forgotten to
> >> export - other symbols of the hrtimers API
> > Are there actual in-tree users of this symbol? Without we usually leave
> > the symbol unexported, this saves some space.
> Do you mean it was really left intentional?
> Unbeleivable! But why the other parts of a
> hrtimer API are exported nevertheless, and
> only this particular function not?

It was probably an oversight - generally we take the position that all the
formal interface of a subsystem is exported to modules rather than a
piecemeal whichever-bits-kernel.org-happens-to-use-today approach.

Thomas, is hrtimer_forward() considered part of the hrtimer public API? 
And are you OK with the patch?


> As for the users - I am porting my pcsp driver to
> it and I need that function.
> It is not exactly in-tree stuff, but it was
> in an ALSA tree for years already, so it is a
> close one.
