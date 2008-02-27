Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbYB0WSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbYB0WSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760008AbYB0WRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:17:47 -0500
Received: from namei.org ([69.55.235.186]:42553 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757875AbYB0WRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:17:46 -0500
Date: Thu, 28 Feb 2008 09:16:18 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Paul Moore <paul.moore@hp.com>
cc: Adrian Bunk <bunk@kernel.org>, sds@tycho.nsa.gov, eparis@parisplace.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] selinux/netlabel.c should #include "netlabel.h"
In-Reply-To: <200802271642.57556.paul.moore@hp.com>
Message-ID: <Xine.LNX.4.64.0802280916020.19162@us.intercode.com.au>
References: <20080227212042.GK29269@cs181133002.pp.htv.fi>
 <200802271642.57556.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Paul Moore wrote:

> On Wednesday 27 February 2008 4:20:42 pm Adrian Bunk wrote:
> > Every file should include the headers containing the externs for its
> > global code.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> It doesn't _need_ the file in the strictest sense, the header file is 
> just there for the core SELinux code to call into the NetLabel/SELinux 
> glue code (what is in security/selinux/netlabel.c).  However, if this 
> is to conform better to kernel coding policy (I assume that is the case 
> here?) then that is fine with me.
> 
> Acked-by: Paul Moore <paul.moore@hp.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#next

-- 
James Morris
<jmorris@namei.org>
