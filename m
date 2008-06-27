Return-Path: <linux-kernel-owner+w=401wt.eu-S1763592AbYF0S3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763592AbYF0S3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbYF0S3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:29:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:50868 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbYF0S3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:29:35 -0400
Date: Fri, 27 Jun 2008 20:29:32 +0200
From: Bernhard Walle <bwalle@suse.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Vivek Goyal <vgoyal@redhat.com>, x86@kernel.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation
 automatically
Message-ID: <20080627202932.16634031@kopernikus.site>
In-Reply-To: <m1zlp6vjub.fsf@frodo.ebiederm.org>
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	<20080627133256.GB5801@redhat.com>
	<20080627134212.GC5801@redhat.com>
	<20080627160656.06f71661@halley.suse.de>
	<20080627141910.GD5801@redhat.com>
	<20080627162223.2df5a8b9@halley.suse.de>
	<m1zlp6vjub.fsf@frodo.ebiederm.org>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* ebiederm@xmission.com (Eric W. Biederman) [2008-06-27 11:00]:
> Bernhard Walle <bwalle@suse.de> writes:
> 
> > Ah, that's true. Only on x86, right? (That would be an alternative for
> > ia64, too ...)
> >
> > But in general policy should go in userspace (if possible), so I agree
> > with you that kexec-tools can handle that.
> 
> At a quick skim the patch looks good.  I thought I had initially implemented
> the code to work this way but apparently in all of the churn that aspect of it
> got lost.
> 
> Let's start with trying to allocate the memory as low as possible for
> a crash kernel (I think you are already doing that).

Yes, in 95 % of the cases the crashkernel still gets reserved at 16M.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
