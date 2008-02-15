Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYBOQ6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYBOQ6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYBOQ55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:57:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:51984 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYBOQ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:57:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kCUaKAWUfzIcPc3fXjEcXMCf61Vfbur1CZ/+2AJAviRhiGbMfWTm5yptddGAyXOQlDc0+Vliqwof+XoIEG3/PL1U4S0F0MDInd4mRq0aEzI3Z9GU8i4eO5Z9LkE1bhKJvP0O39ES5keVE2ry8E84T9PgW11sUMyRxN7uDHu9SgM=
Message-ID: <6101e8c40802150857h656efbf9of2646e9ae8c07a5b@mail.gmail.com>
Date: Fri, 15 Feb 2008 17:57:53 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] Make sysctl a separate filesystem
Cc: "Mikael Pettersson" <mikpe@it.uu.se>, "Andi Kleen" <andi@firstfloor.org>,
       "Pavel Emelyanov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Alexey Dobriyan" <adobriyan@openvz.org>
In-Reply-To: <Pine.LNX.4.64.0802151343330.30301@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B56BF2.4020600@openvz.org> <p73ejbe1ook.fsf@bingen.suse.de>
	 <18357.30971.334517.722985@harpo.it.uu.se>
	 <Pine.LNX.4.64.0802151343330.30301@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/08, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Feb 15 2008 12:35, Mikael Pettersson wrote:
> >Andi Kleen writes:
> > > Pavel Emelyanov <xemul@openvz.org> writes:
> > > > this subdir;
> > > > 3. sysctl inodes are now smaller than the procfs ones.
> > >
> > > That's always a good thing.
> > >
> > > > Note: update your initscripts to mount sysctl filesystem
> > > > right after the proc is mounted in order not to lose your
> > > > /etc/sysctl.conf configuration (and optionally fstab).
> > >
> > > That will break about everybody's init scripts I suspect.
> > >
> > > I think you would need to go through some deprecation
> > > period for this at least, with printks warning people
> > > to fix their init scripts.
> > >
> > > Or better find some way to do the mount automatically.
> >
> >Doing it automatically is the only acceptable way, IMO.
>
> For time being only.
>
> The kernel (currently) only auto-mounts invisible filesystems.
 and /selinux with selinuxfs, it is automounted ... but it is visible fs


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>
--
Thanks,
Oliver
