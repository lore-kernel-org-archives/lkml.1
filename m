Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZL3ISW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZL3ISW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 03:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZL3ISU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 03:18:20 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:34502 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZL3IST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 03:18:19 -0500
Date: Wed, 30 Dec 2009 03:17:47 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Valdis.Kletnieks@vt.edu
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: simplify numerous param.h's by including
 <asm-generic/param.h>?
In-Reply-To: <9192.1262110147@localhost>
Message-ID: <alpine.LFD.2.00.0912300316070.11919@localhost>
References: <alpine.LFD.2.00.0912291224520.2860@localhost> <9192.1262110147@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Tue, 29 Dec 2009, Valdis.Kletnieks@vt.edu wrote:

> On Tue, 29 Dec 2009 12:30:23 EST, "Robert P. J. Day" said:
> >
> >   a brief perusal of the numerous param.h files under
> > arch/<arch>/include/asm shows that most of them could be replaced with
> > a simple
> >
> >   #include <asm-generic/param.h>
>
> >   worth doing?  not worth doing?
>
> Anytime you can fix "You are in a twisty maze of #include files, all
> subtly different" issues, it is a Good Thing.
>
> Thanks for all the de-cruftifying efforts you've made.

  ok, so i'm assuming there's no legitimate objection to having
numerous arch-specific param.h files simply refer to
<asm-generic/param.h> if that's appropriate.  i'll submit individual
patches on a per-arch basis to the appropriate MLs.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
