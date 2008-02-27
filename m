Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYB0WIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYB0WIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbYB0WII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:08:08 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:25310 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbYB0WIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:08:06 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] selinux/netlabel.c should #include "netlabel.h"
Date: Wed, 27 Feb 2008 17:08:04 -0500
User-Agent: KMail/1.9.7
Cc: sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080227212042.GK29269@cs181133002.pp.htv.fi> <200802271642.57556.paul.moore@hp.com> <20080227215543.GW29269@cs181133002.pp.htv.fi>
In-Reply-To: <20080227215543.GW29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271708.04766.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008 4:55:43 pm Adrian Bunk wrote:
> On Wed, Feb 27, 2008 at 04:42:57PM -0500, Paul Moore wrote:
> > On Wednesday 27 February 2008 4:20:42 pm Adrian Bunk wrote:
> > > Every file should include the headers containing the externs for
> > > its global code.
> > >
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > It doesn't _need_ the file in the strictest sense, the header file
> > is just there for the core SELinux code to call into the
> > NetLabel/SELinux glue code (what is in
> > security/selinux/netlabel.c).  However, if this is to conform
> > better to kernel coding policy (I assume that is the case here?)
> > then that is fine with me.
>
> I'm not claiming it needs it.
>
> But with this #include gcc can check that the prototypes in
> netlabel.h match the functions in netlabel.c
>
> The bugs this catches are rare, but when you have such a bug it can
> be nasty to debug.

Good point, hadn't thought of that - thanks.  

> > Acked-by: Paul Moore <paul.moore@hp.com>

-- 
paul moore
linux security @ hp
