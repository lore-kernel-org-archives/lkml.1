Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbXF0QDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbXF0QDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbXF0QDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:03:08 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37972 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbXF0QDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:03:07 -0400
X-Originating-Ip: 99.246.112.70
Date: Wed, 27 Jun 2007 11:59:18 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
cc: mrmacman_g4@mac.com, bunk@stusta.de, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, david@lang.hm
Subject: Re: Linux Kernel include files
In-Reply-To: <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de>
Message-ID: <Pine.LNX.4.64.0706271159001.4668@localhost.localdomain>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
 <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de>
 <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de>
 <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Joerg Schilling wrote:

> Adrian Bunk <bunk@stusta.de> wrote:
>
> > That's a good point I missed.
> >
> > What about:
> >
> > #if defined(__GNUC__) && __STDC_VERSION__ < 19901L
> > __extension__ typedef   signed long long __s64;
> > __extension__ typedef unsigned long long __u64;
> > #else
> > typedef   signed long long __s64;
> > typedef unsigned long long __u64;
> > #endif
>
> What about using:
>
> #if (defined(__GNUC__) || defined(__SUNPRO_C)) && !defined(__STRICT_ANSI__)
>
> Well, there seems to be one other compiler (the one from Intel).
> It may be that if this compiler does not claim to be GCC, another
> definituion needs to be added.

the intel compiler does indeed claim to be gcc.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
