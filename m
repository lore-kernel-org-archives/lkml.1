Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZEWOMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZEWOMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 10:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZEWOMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 10:12:45 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:58031 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZEWOMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 10:12:44 -0400
Date: Sat, 23 May 2009 10:11:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, sam@ravnborg.org
Subject: Re: "make config" to another architecture doesn't relink
 include/asm
In-Reply-To: <200905231322.16154.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0905231010570.7113@localhost.localdomain>
References: <alpine.LFD.2.00.0905221219500.13933@localhost.localdomain> <200905231322.16154.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-478106526-1243087881=:7113"
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

--8323328-478106526-1243087881=:7113
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 23 May 2009, Arnd Bergmann wrote:

> On Friday 22 May 2009, Robert P. J. Day wrote:
> > =A0 shouldn't it be sufficient that, if i do another "make
> > ??_defconfig" to another architecture, all traces of the previous
> > configure are erased and include/asm should be relinked
> > automatically?

> In 2.6.30, the symlink is finally no longer needed, so maybe we
> should simply drop it to solve this problem as well.

  or that could work, too.  :-)

rday
--


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-478106526-1243087881=:7113--
