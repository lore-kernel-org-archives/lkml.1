Return-Path: <linux-kernel-owner+w=401wt.eu-S932856AbYDQTL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbYDQTL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYDQTLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:11:49 -0400
Received: from www.tglx.de ([62.245.132.106]:42608 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbYDQTLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:11:48 -0400
Date: Thu, 17 Apr 2008 21:11:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: Alex Dubov <oakad@yahoo.com>, Ben Dooks <ben@fluff.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Smartmedia/xd card support - request for comments
In-Reply-To: <20080417140734.GA30001@logfs.org>
Message-ID: <alpine.LFD.1.10.0804172109170.3261@apollo.tec.linutronix.de>
References: <257448.48285.qm@web36701.mail.mud.yahoo.com> <alpine.LFD.1.10.0804171535581.3261@apollo.tec.linutronix.de> <20080417140734.GA30001@logfs.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2027415981-1208459492=:3261"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2027415981-1208459492=:3261
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 17 Apr 2008, Jörn Engel wrote:
> On Thu, 17 April 2008 15:38:17 +0200, Thomas Gleixner wrote:
> > 
> > No it is not. SmardMedia is a bare NAND chip, which is already covered
> > by MTD. There are already other FTLs on top of MTD and the SmartMedia
> > format just can be added to those.
> 
> Isn't drivers/mtd/ssfdc.c - despite its name - an implementation of the
> SmartMedia FTL?  When I last looked at it, I failed to see any
> functional differences.

Oops. I did not bother to look into drivers/mtd and for some reason it
slipped out of my memory that it got mainlined. It's read only, but
the missing bits to make it r/w are not that hard. At least less code
than duplicating code all over the place for no good reason.

Thanks,
	tglx


--8323328-2027415981-1208459492=:3261--
