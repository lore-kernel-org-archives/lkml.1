Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYESOkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYESOkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYESOkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:40:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37360 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbYESOkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:40:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #10645] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
Date: Mon, 19 May 2008 16:40:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, mikpe@it.uu.se
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.S1.BtBMIB@albercik> <20080518.211339.186246662.davem@davemloft.net>
In-Reply-To: <20080518.211339.186246662.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191640.20538.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 of May 2008, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sun, 18 May 2008 13:13:55 +0200 (CEST)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10645
> > Subject		: 2.6.26-rc1 lost half the RAM on UltraSPARC 5
> > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > Date		: 2008-05-07 20:36 (12 days old)
> > References	: http://lkml.org/lkml/2008/5/7/204
> > Handled-By	: David Miller <davem@davemloft.net>
> 
> Fixed by:
> 
> commit 7047901ec7d6eca97cf66f54b8a4197bb0754f40
> Author: David S. Miller <davem@davemloft.net>
> Date:   Wed May 14 23:10:33 2008 -0700
> 
>     sparc64: Fix lmb_reserve() args in find_ramdisk().
>     
>     This fixes the missing ram regression reported by
>     Mikael Pettersson <mikpe@it.uu.se>, much thanks for
>     all of this help in diagnosing this.
>     
>     The second argument to lmb_reserve() is a size,
>     not an end address bounds.
>     
>     Tested-by: Mikael Pettersson <mikpe@it.uu.se>
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Adrian has already closed the bug.

Thanks,
Rafael
