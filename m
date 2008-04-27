Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbYD0DDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbYD0DDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 23:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbYD0DDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 23:03:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:49130 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYD0DDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 23:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WSFBYCzNDHRi3DqQMH0KpqpNqsSiTKjZi/cPIeDwTdKbIvKaeJvhy5JCl8EBEzvTRie6pMDZa/zllmSx5c85oizoONwWr0lD19W1TiFIKEOmDpBBNFBYhHF6vwohR0RnFCv9D4+b80oZC3glEAvqxBIQRS5WmMVmKJLwUTiO8uc=
Message-ID: <29495f1d0804262003p6e24ef5cpfe21d7f9f1e4f75b@mail.gmail.com>
Date: Sat, 26 Apr 2008 20:03:32 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: 2.6.25-mm1 (no disks with sata_nv)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080427025547.GC24710@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <29495f1d0804261912k584cb68p36f4b9e5401afbb8@mail.gmail.com>
	 <20080427025547.GC24710@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/08, Jeff Garzik <jeff@garzik.org> wrote:
> On Sat, Apr 26, 2008 at 07:12:58PM -0700, Nish Aravamudan wrote:
>  >
>  > While trying to test the hugepage changes pending for -mm, I found
>  > that none of my 4 disks attached to
>  >
>  > nVidia Corporation CK804 Serial ATA Controller (rev f3)
>  >
>  > come up (and thus I am dropped to an initramfs shell). The driver is
>  > loading and indicates a link up on all 4 ports that are involved, but
>  > I see no sd/sdX messages like I do with 2.6.25 (which I'm using right
>  > now). I've started the bisection, but if Jeff or anyone has any ideas,
>  > I'd appreciate it. I don't have a serial console on this box, and no
>  > oops is produced. .configs from 2.6.25 and 2.6.25-mm1 attached.
>
>
> Should be fixed in upstream, so I presume it will appear when Andrew
>  next updates his kernel to the latest upstream.

Ah great -- do you have a single patch I can apply that will fix it so
I can test? (FWIW, reverting the git-libata-all patch from -mm got me
booting). Should I assume it's a sata_nv only commit I can cherry-pick
over?

Thanks,
Nish
