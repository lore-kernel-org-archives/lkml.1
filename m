Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbZD2R2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbZD2R2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZD2R2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:28:24 -0400
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:47955 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751099AbZD2R2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:28:23 -0400
Message-ID: <74227.8192.qm@web32607.mail.mud.yahoo.com>
X-YMail-OSG: OUFMKHcVM1leLMK6p5MgIsLqWEi_nsOrDxUTbR3NntCGi.KgVShq.G4W3GfhSBWM8kMKsoZY6KnNQk4r3E.ccVRbmIQdtTdDSBqalpjNe4rT885HzdztHe1ODo459GIhOg6DIR2H0Ka7a3G3Q71uFdzaxyVEpd4XguWYi3r3sOmnIvoyIFgOZlbc1N9hR3WveSa.CqKYu86D52HuG.h2Phl8nKkGWs19KhHwZJg1RxIMFwuvF6zuOyXsgR6Cwc_bGa3jfQIYPdF_kCLvjVnJhfRvo.Vns_IAJoqL_nj_Vs2NE3SR.k8X200pqfTGa1Cvb9bCwJfzP7E1s2iK.I8q6zc-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <1241014725.15095.19.camel@marge.simson.net> <20090429143403.GJ8633@ZenIV.linux.org.uk>
Date: Wed, 29 Apr 2009 10:28:23 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
To: Al Viro <viro@ZenIV.linux.org.uk>, Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
In-Reply-To: <20090429143403.GJ8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Al Viro <viro@ZenIV.linux.org.uk>
> To: Mike Galbraith <efault@gmx.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>; Martin Knoblauch <knobi@knobisoft.de>; Rafael J. Wysocki <rjw@sisk.pl>; linux-kernel@vger.kernel.org; tigran aivazian <tigran@aivazian.fsnet.co.uk>
> Sent: Wednesday, April 29, 2009 4:34:03 PM
> Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> 
> On Wed, Apr 29, 2009 at 04:18:45PM +0200, Mike Galbraith wrote:
> > > /etc/fstab, perhaps?  That definitely looks like two mount(2) had to
> > > have been done to cause that...
> > 
> > Yeah, but how does one go about doing that?
> > 
> > Using mount -f, I can convince mount to succeed, but I still have only
> > one entry in /proc/mounts, despite what my mount binary imagines.
> 
> Huh?
>        -f     Causes  everything to be done except for the actual system call;
>               if it's not obvious, this ``fakes'' mounting  the  file  system.
>               This  option is useful in conjunction with the -v flag to deter-
>               mine what the mount command is trying to do. It can also be used
>               to add entries for devices that were mounted earlier with the -n
> 
> What are you talking about?
> 
> The interesting part is why mount(2) doesn't fail with -EBUSY on that
> overmounting.  Is there anything else mounted on /sys?  That, or any
> interesting patches applied to the tree (fs/sysfs/mount.c, fs/namespace.c)

 In my 2.6.30-rc3-git2 there is definitely nothing interesting, just my NFS readahead patch. But that touches nothing near sysfs.  And my 2.6.29 test-boot was from a plain build.

Cheers
Martin

