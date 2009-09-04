Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbZIDQxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbZIDQxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbZIDQxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:53:49 -0400
Received: from ru.mvista.com ([213.79.90.228]:9378 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755015AbZIDQxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:53:49 -0400
Date: Fri, 4 Sep 2009 20:53:48 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH RFC 1/2] Makefile: Never use -fno-omit-frame-pointer
Message-ID: <20090904165348.GA1287@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090616201630.GA4971@oksana.dev.rtsoft.ru>
 <20090714133716.GC28970@oksana.dev.rtsoft.ru>
 <20090718120145.GB31007@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090718120145.GB31007@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 02:01:45PM +0200, Ingo Molnar wrote:
> 
> * Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > On Wed, Jun 17, 2009 at 12:16:30AM +0400, Anton Vorontsov wrote:
> > > According to Segher Boessenkool and GCC manual, -fomit-frame-pointer
> > > is only the default when optimising on archs/ABIs where it doesn't
> > > hinder debugging and -pg. So, we do not get it by default on x86,
> > > not at any optimisation level.
> > > 
> > > On the other hand, *using* -fno-omit-frame-pointer causes gcc to
> > > produce buggy code on PowerPC targets.
> > > 
> > > If Segher and GCC manual are right, this patch should be a no-op
> > > for all arches except PowerPC, where the patch fixes gcc issues.
> > > 
> > > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > > ---
> > > 
> > > See this thread for more discussion:
> > > http://osdir.com/ml/linux-kernel/2009-05/msg01754.html
> > > 
> > > p.s.
> > > Obviously, I didn't test this patch on anything else but PPC32. ;-)
> > > 
> > > Segher, do you know if all GCC versions that we support for
> > > building Linux are behaving the way that GCC manual describe?
> > 
> > No news is good news... Ingo, can we merge this into -tip for 
> > testing?
> 
> Changes to the top level Makefile should really go via Sam's kbuild 
> tree.

Sam, any thoughts about these patches?

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
