Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbYKNDFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbYKNDFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYKNDEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:04:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49606
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbYKNDEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:04:48 -0500
Date: Thu, 13 Nov 2008 19:04:47 -0800 (PST)
Message-Id: <20081113.190447.252605555.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, cloos@jhcloos.com, paul@burly.ondioline.org,
       torvalds@linux-foundation.org
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081113.185059.154690040.davem@davemloft.net>
References: <20081113.151116.139760511.davem@davemloft.net>
	<1226624060.7178.100.camel@pasglop>
	<20081113.185059.154690040.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 13 Nov 2008 18:50:59 -0800 (PST)

> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Fri, 14 Nov 2008 11:54:20 +1100
> 
> > How does it compare with not having the acceleration ?
> 
> I'll find out for you.

It makes a huge difference, with the acceleration patch:

commit b1ee26bab14886350ba12a5c10cbc0696ac679bf
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Wed Oct 15 22:03:46 2008 -0700

    radeonfb: accelerate imageblit and other improvements

reverted, the test case takes 25 seconds or more instead of
the 7 or 8 seconds we're seeing now.
