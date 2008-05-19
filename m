Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYESENw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYESENw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 00:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYESENp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 00:13:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45924
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbYESENo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 00:13:44 -0400
Date: Sun, 18 May 2008 21:13:39 -0700 (PDT)
Message-Id: <20080518.211339.186246662.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, mikpe@it.uu.se
Subject: Re: [Bug #10645] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
From: David Miller <davem@davemloft.net>
In-Reply-To: <7wuznNhcUqC.A.S1.BtBMIB@albercik>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	<7wuznNhcUqC.A.S1.BtBMIB@albercik>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun, 18 May 2008 13:13:55 +0200 (CEST)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10645
> Subject		: 2.6.26-rc1 lost half the RAM on UltraSPARC 5
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2008-05-07 20:36 (12 days old)
> References	: http://lkml.org/lkml/2008/5/7/204
> Handled-By	: David Miller <davem@davemloft.net>

Fixed by:

commit 7047901ec7d6eca97cf66f54b8a4197bb0754f40
Author: David S. Miller <davem@davemloft.net>
Date:   Wed May 14 23:10:33 2008 -0700

    sparc64: Fix lmb_reserve() args in find_ramdisk().
    
    This fixes the missing ram regression reported by
    Mikael Pettersson <mikpe@it.uu.se>, much thanks for
    all of this help in diagnosing this.
    
    The second argument to lmb_reserve() is a size,
    not an end address bounds.
    
    Tested-by: Mikael Pettersson <mikpe@it.uu.se>
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

