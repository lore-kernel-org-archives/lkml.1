Return-Path: <linux-kernel-owner+w=401wt.eu-S1764834AbXGJSrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764834AbXGJSrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXGJSrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:47:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbXGJSrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:47:11 -0400
Date: Tue, 10 Jul 2007 11:47:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       <linux-kernel@vger.kernel.org>,
       "Leech, Christopher" <christopher.leech@intel.com>
Subject: Re: -mm merge plans for 2.6.23 - ioat/dma engine
Message-Id: <20070710114703.a24eb7bd.akpm@linux-foundation.org>
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C02A5736C@orsmsx418.amr.corp.intel.com>
References: <4693B47B.7050406@intel.com>
	<BAE9DCEF64577A439B3A37F36F9B691C02A5736C@orsmsx418.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 11:05:45 -0700
"Nelson, Shannon" <shannon.nelson@intel.com> wrote:

> Kok, Auke wrote: 
> >Andrew Morton wrote:
> >> git-ioat-vs-git-md-accel.patch
> >> ioat-warning-fix.patch
> >> fix-i-oat-for-kexec.patch
> >> 
> >>  I don't seem to be able to get rid of these.  Chris Leech 
> >appears to have
> >>  vanished.
> >
> >Chris is a moving target. Thankfully we have Shannon Nelson 
> >taking over Chris' 
> >duties. Shannon, can you take a look at these and see what 
> >needs to happen to it 
> >? Most likely these just need to be pushed to the right person.
> 
> Auke: Thanks for the introduction :-).

Hi, Shannon.

> Andrew: All three of these patches are reasonable and can be pushed on
> up.  You can add my sign-off to all three:
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>

OK, the way it works is that I send these patches at the git tree
maintainer, then the git tree maintainer merges them (this step is
unreliable) and then when I repull that git tree maintainer's tree I see
that they got merged so I drop them from -mm.  The git tree maintainer
decides when to send them to Linus.

I am presently pulling git://lost.foo-projects.org/~cleech/linux-2.6#master
into -mm.

Will you be taking over the IOAT git tree?  If so, please send me a
suitable git URL when it's ready.

The above tree has several changes in it from January (see
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/git-ioat.patch).
 Please take a look at those, work out what we should do with it all.

