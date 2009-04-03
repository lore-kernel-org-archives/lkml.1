Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZDCAin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZDCAin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbZDCAie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:38:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49374 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbZDCAid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:38:33 -0400
Date: Thu, 2 Apr 2009 17:38:28 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-ish "fixes" in UBIFS
In-Reply-To: <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0904021731060.6162@bogon.housecafe.de>
References: <49CCCB0A.6070701@nokia.com>  <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>  <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com> <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19EY2+ajohD78HT9i3qqZoOQsxgBytlvsQpplE
 iJWbznc71FWdPsUNkueznJww92WH+Tq1pT8shCGwm7C35FWmNm
 15xTGTKzuOkfHcGD/bCow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Trenton D. Adams wrote:
> Oh, I should have clarified.  It improves performance under heavy
> load.  Under normal load, mounting without sync is fine.  What I tend
> to do is mount with "remount,rw,sync" when heavy load is starting.

Really? How does mounting with "-o sync" *improve* performance? I am 
certainly aware that mounting with "-o sync" has severe performance 
impacts, but was proposing it anyway *only* to tackle the data integrity 
problem. However, I'm curious if usescaes in the embedded world are 
equally affected by this.

> I'm thinking of writing a script that monitors performance, and
> remounts as needed, lol.  WHAT A HACK. hehe.

Ugh....my brain hurts :-\

Christian.
-- 
Bruce Schneier once found three distinct natural number divisors of a prime
number.
