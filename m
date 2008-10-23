Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYJWFKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYJWFKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 01:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYJWFKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 01:10:42 -0400
Received: from 1wt.eu ([62.212.114.60]:4887 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbYJWFKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 01:10:41 -0400
Date: Thu, 23 Oct 2008 07:06:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/17] 2.6.27-stable review
Message-ID: <20081023050625.GA9932@1wt.eu>
References: <20081018183334.GA14035@suse.de> <20081023010126.GB30920@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023010126.GB30920@zod.rchland.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 09:01:26PM -0400, Josh Boyer wrote:
> On Sat, Oct 18, 2008 at 11:33:34AM -0700, Greg KH wrote:
> >This is the start of the stable review cycle for the 2.6.27.3 release.
> >There are 17 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let us know.  If anyone is a maintainer of the proper subsystem, and
> >wants to add a Signed-off-by: line to the patch, please respond with it.
> >
> >These patches are sent out with a number of different people on the
> >Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
> >to add your name to the list.  If you want to be off the reviewer list,
> >also email us.
> >
> >Responses should be made by Wed, October 22, 2008 19:00:00 UTC.
> >Anything received after that time might be too late.
> 
> OK, I realize I'm late.  Apologies in advance for that.
> 
> I don't see how patches 3, 16, and 17 really fit into the "stable"
> rules.  None of them:
> 
> "... fix a problem that causes a build error (but not for things
>  marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
>  security issue, or some "oh, that's not good" issue.  In short,
>  something critical."
> 
> So, are we being a bit more lax on the requirements for the
> -stable kernels and I missed the memo, or?

3 definitely is "oh that's not good", and 16&17 are just support
for a few new IDs. It's not the first time this happens, and as
long as there are not too many or they don't change the driver's
code, I don't see the problem. It increases the ability for people
to test the kernel and report bugs too BTW.

I think it's better to have strict rules and be lax sometimes
than having no rules at all or being too strict and annoy users.

Willy

