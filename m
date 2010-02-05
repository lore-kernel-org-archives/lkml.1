Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0BETar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 14:30:47 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:37203 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752711Ab0BETap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:30:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RCkygtiQ1ymoX8Kz7D4RDS0T3oWKKi7+LkRHsVkuxXZsFYTlRpvvJP/nzMkOEIxGuyBoDZWveGP5j4mQccxWoh2hGpyRdom+Q96V7tGd78j6iToxv6n6l8DQ2SacQ4kW;
Date: Fri, 5 Feb 2010 11:29:52 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Soeren Sonnenburg <sonne@debian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [Bug #15043] Display goes off with i915.powersave=1 after
 suspend-resume
Message-ID: <20100205112952.01affddb@jbarnes-piketon>
In-Reply-To: <201002042142.02127.rjw@sisk.pl>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	<d3IDKWHT5gE.A.-nC.G8hZLB@chimera>
	<1265314137.10203.0.camel@no>
	<201002042142.02127.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 21:42:02 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday 04 February 2010, Soeren Sonnenburg wrote:
> > On Mon, 2010-02-01 at 01:22 +0100, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a
> > > report of recent regressions.
> > > 
> > > The following bug entry is on the current list of known
> > > regressions from 2.6.32.  Please verify if it still should be
> > > listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry	:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=15043
> > > Subject		: Display goes off with i915.powersave=1
> > > after suspend-resume Submitter	: Soeren Sonnenburg
> > > <sonne@debian.org> Date		: 2010-01-10 20:09 (22
> > > days old) References	:
> > > http://marc.info/?l=linux-kernel&m=126315457519505&w=4
> > 
> > yes still exists in current git.
> 
> Thanks for the update.

Just updated the corresponding FDO bug
(https://bugs.freedesktop.org/show_bug.cgi?id=24314).  There are some
hw bugs related to FBC handling on 945GM though, so we may have to
disable it on some machines.

-- 
Jesse Barnes, Intel Open Source Technology Center
