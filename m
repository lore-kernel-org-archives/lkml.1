Return-Path: <linux-kernel-owner+w=401wt.eu-S1761492AbZFKQiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761492AbZFKQiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZFKQhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:37:54 -0400
Received: from outbound-mail-24.bluehost.com ([69.89.21.19]:36819 "HELO
	outbound-mail-24.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753549AbZFKQhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:37:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NS37D9zMTTprx6hhilkmsuTUPKXRruHI8hD4nOj4DvSsBv6oqdK22QP0N74Vhp+3zeGqH6WKRKY1zoLzzZp2tno+bB69UMJSOBjPPxClMwzIDjyn74wzfYBZOz1r96rr;
Date: Thu, 11 Jun 2009 09:37:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       eric@anholt.net, linux-acpi@vger.kernel.org
Subject: Re: 2.6.30-rc6: i915: Xserver crash - oops after rmmod
Message-ID: <20090611093707.5d20af25@jbarnes-g45>
In-Reply-To: <4A1E1D95.5060409@gmail.com>
References: <4A11B52E.7080808@gmail.com>
	<20090527171414.108710cf.akpm@linux-foundation.org>
	<4A1E1D95.5060409@gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 07:13:57 +0200
Niel Lambrechts <niel.lambrechts@gmail.com> wrote:

> Hi Andrew,
> 
> On 05/28/2009 02:14 AM, Andrew Morton wrote:
> > On Mon, 18 May 2009 21:21:18 +0200
> > Niel Lambrechts <niel.lambrechts@gmail.com> wrote:
> >
> >   
> >> Hi,
> >>     
> > Huge response, huh?
> >   
> Yeah, no one fell for the humour coating... ;-)
> 
> > The wordwrapping makes this painful to read.
> >
> > rmmod crashed under drivers/acpi/video.c:acpi_video_exit()'s call to
> > acpi_bus_unregister_driver().  So it might be an acpi-related bug.
> >
> > If it's reproducible at all, please raise a (non-wordwrapped!)
> > report against acpi at bugzilla.kernel.org, thanks.
> >   
> Ugh, Thunderbird doesn't format it like this when you preview - but
> when I save it to a file it looks horrible...
> 
> I don't think I would easily be able to reproduce this, but I still
> had a copy of my kernel log for that date. The bug is filed at:
> http://bugzilla.kernel.org/show_bug.cgi?id=13396
> 
> Also, if you do have a moment, I'd love to hear your opinion on my
> post "2.6.29.4: hibernation fails with large kernel trace"!
> 
> Thanks for the response!

Btw I think this is fixed now (I noticed it recently but it's gone
now).  IIRC it was a bug caused by trying to uninit the ACPI video
portion of the driver twice at unload time.

-- 
Jesse Barnes, Intel Open Source Technology Center
