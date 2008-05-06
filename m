Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYEFUfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYEFUfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbYEFUeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:34:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43567
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933062AbYEFUeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:34:21 -0400
Date: Tue, 06 May 2008 13:34:16 -0700 (PDT)
Message-Id: <20080506.133416.241365936.davem@davemloft.net>
To: arjan@linux.intel.com
Cc: kjwinchester@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: linux-next: WARNING: at kernel/panic.c:375
 __stack_chk_test+0x50/0x54()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4820B64D.4000805@linux.intel.com>
References: <20080501043313.02205bbd@linux.intel.com>
	<481CF3B1.2020307@gmail.com>
	<4820B64D.4000805@linux.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 06 May 2008 12:49:33 -0700

> this is weird; something is adding ANOTHER -fstack-protector to the (effective) gcc
> flags.. which might be overriding the -fstack-protector-all setting.
> 
> I wonder if this is a distro special ;(

Ubuntu adds -fstack-protector to the GCC command line.

But I've been able to override it trivially when, for example, doing
GCC builds, by simply adding -fno-stack-protector.
