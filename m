Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZCKPxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZCKPxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbZCKPxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:53:37 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:61973 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750769AbZCKPxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:53:37 -0400
Date: Wed, 11 Mar 2009 16:53:34 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
In-Reply-To: <alpine.LFD.2.00.0903110835020.32478@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.0903111652070.1040@vixen.sonytel.be>
References: <1236729444.7086.24.camel@pasglop> <alpine.LRH.2.00.0903111028480.1040@vixen.sonytel.be> <1236769025.7086.46.camel@pasglop> <alpine.LFD.2.00.0903110835020.32478@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

On Wed, 11 Mar 2009, Linus Torvalds wrote:
> On Wed, 11 Mar 2009, Benjamin Herrenschmidt wrote:
> > I'd like to have Andrew or Linus opinion on doing this driver swap that
> > late in the process.
> 
> Quite franklly, no. 
> 
> If it was a totally _new_ driver, there's no chance of regression, which 
> is why we allow those drivers.
> 
> But switching an old one for a new one does not match that pattern. We can 
> clearly get regressions. As such, we don't do it late in the -rc series.

Are you aware the old one was introduced in 2.6.29-rc1? So there cannot be a
regression from 2.6.28 or older.

Thanks!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
