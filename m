Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYANUyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYANUyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYANUyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:54:07 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:49952 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYANUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:54:06 -0500
Date: Mon, 14 Jan 2008 15:53:58 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: =?ISO-8859-15?Q?Dagfinn_Ilmari_Manns=E5ker?= <ilmari@ilmari.org>
cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Possibly silly Q?
In-Reply-To: <d8jmyr8xjyi.fsf@nygaard.ping.uio.no>
Message-ID: <alpine.LFD.1.00.0801141551260.26152@localhost.localdomain>
References: <200801141434.00934.gene.heskett@gmail.com> <d8jmyr8xjyi.fsf@nygaard.ping.uio.no>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1775907124-1200344041=:26152"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1775907124-1200344041=:26152
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 14 Jan 2008, Dagfinn Ilmari Manns=C3=A5ker wrote:

> Gene Heskett <gene.heskett@gmail.com> writes:
>
> > Greetings;
> >
> > Do we have a utility that can force the kernel to re-read, and re-initi=
alize
> > itself to a given drives partition tables without having to reboot if o=
ne is
> > working with a drive that is not part of the required kernel directory =
tree?
> [=E2=80=A6]
> > Something it seems to me, should have forced the re-init, but didn't.  =
So is
> > there a tool that can force that?
>
> fdisk or similar should have issued an ioctl to reread the partition
> table after writing the new one, but you can do it manually with
> 'blockdev --rereadpt <device>'.

i remember bringing up this very issue quite some time ago and, IIRC,
the consensus was that *primary* partition changes would be re-read by
the kernel, but not *logical* partition changes.  or something sort of
like that.

rday
--

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

Home page:                                         http://crashcourse.ca
Fedora Cookbook:    http://crashcourse.ca/wiki/index.php/Fedora_Cookbook
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-1775907124-1200344041=:26152--
