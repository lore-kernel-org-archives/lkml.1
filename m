Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYEGBLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYEGBLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYEGBLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:11:30 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63299 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753146AbYEGBL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:11:29 -0400
Date: Wed, 7 May 2008 02:11:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: rtc_time_to_tm: use unsigned arithmetic
In-Reply-To: <4820E0C6.10309@gmail.com>
Message-ID: <Pine.LNX.4.55.0805070207230.16173@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805062315530.16173@cliff.in.clinika.pl>
 <4820E0C6.10309@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Dmitri Vorobiev wrote:

> > -	register int days, month, year;
> > +	register unsigned int days, month, year;
> 
> Does it make any sense to use the `register' keyword nowadays?

 It may or may not -- I have not investigated it that thoroughly.  It is
still correct syntax and a valid optimization hint -- I could imagine the
-Os mode utilizing it on some architecture that can do ALU operations on
memory.

  Maciej
