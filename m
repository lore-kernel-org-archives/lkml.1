Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYGNSrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYGNSrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYGNSrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:47:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:49595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbYGNSrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:47:08 -0400
Date: Mon, 14 Jul 2008 20:47:48 +0200
From: Bernhard Walle <bwalle@suse.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Vivek Goyal" <vgoyal@redhat.com>,
       kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation
 automatically
Message-ID: <20080714204748.07b06e30@halley.suse.de>
In-Reply-To: <m1r69wxq8v.fsf@frodo.ebiederm.org>
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	<20080627133256.GB5801@redhat.com>
	<86802c440807140011v728cc35fy2540b537ddca9844@mail.gmail.com>
	<20080714112404.36783df5@halley.suse.de>
	<m1od50ztoa.fsf@frodo.ebiederm.org>
	<86802c440807141006o98afac8t66b0933d8acd2746@mail.gmail.com>
	<m17iboz83v.fsf@frodo.ebiederm.org>
	<86802c440807141117q218fdd61w1216dc6ded72252a@mail.gmail.com>
	<m1r69wxq8v.fsf@frodo.ebiederm.org>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
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

* Eric W. Biederman [2008-07-14 11:41]:
>
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> 
> > On Mon, Jul 14, 2008 at 10:30 AM, Eric W. Biederman
> > <ebiederm@xmission.com> wrote:
> >> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> >>
> >>> for 64bit, kdump can start from address above 4g with bzImage?
> >>
> >> I think the boot protocol was properly updated for that, it was in the
> >> original drafts.  A relocatable kernel with a 64bit entry point.
> >>
> >> I do know that the 64bit code is ready to do that.
> >
> > but bzImage for 64bit still use 32bit entries, except kexec could
> > uncompress the bzImage like xen domain builder.
> 
> From the standpoint of the crashdump option it doesn't matter.
> As the vmlinux supports it, and bzImage could easily support it,
> the decompresser is 64bit code.
> 
> If bzImage doesn't support it that is a bug we will have to
> correct one of these years when it actually matters.

But such checks belong into kexec itself, not into the kernel.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
