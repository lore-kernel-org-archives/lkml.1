Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbZE2Iqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbZE2Iqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757472AbZE2Io2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:44:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:59565 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbZE2Io0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:44:26 -0400
Subject: Re: [PATCH] KVM: add localversion to avoid confusion and conflicts
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Christian =?ISO-8859-1?Q?Borntr=E4ger?= <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
In-Reply-To: <200905290948.34482.borntraeger@de.ibm.com>
References: <1243581494.3212.1.camel@localhost.localdomain>
	 <200905290948.34482.borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 May 2009 14:13:46 +0530
Message-Id: <1243586626.4379.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 09:48 +0200, Christian Bornträger wrote:
> Am Freitag 29 Mai 2009 09:18:14 schrieb Jaswinder Singh Rajput:
> > Adding localversion avoids confusion in kernel images :
> >
> > like Linux version 2.6.30-rc7 does not tell whether it is linus or kvm
> > kernel.
> >
> > By adding localversion it tells :
> >
> > Linux version 2.6.30-rc7-kvm , any doubt ;-)
> > I am inspired by Ingo's -tip, I am sure Ingo will tell more advantages,
> > if these are not enough :-)
> [...]
> > diff --git a/localversion-kvm b/localversion-kvm
> > new file mode 100644
> > index 0000000..d969ff0
> > --- /dev/null
> > +++ b/localversion-kvm
> > @@ -0,0 +1 @@
> > +-kvm
> 
> NAK from my side. If you need a distinction, there is always 
> CONFIG_LOCALVERSION_AUTO. If you need this kind of prefix, there is always  
> CONFIG_LOCALVERSION.
> 

Here is NAK for your NAK from my side.

This patch is only for KVM tree and not for linus tree.

Lets assume 100 developers are working on kvm tree and they use kvm tree
on 2 PCs. So count becomes 200.

Like in my case I have dozen of kernel trees so I keep on swapping
config between kernels. And I also need to test config from various
users. So this count is countless.
I think this is the biggest point for adding localversion in -tip.
It seems Ingo is busy in perfcounter stuff otherwise he will explain you
more advantages.

In the least case, Can you differentiate between 1 and 200 ?

So by adding this patch we can save lot of developer's time.

--
JSR

