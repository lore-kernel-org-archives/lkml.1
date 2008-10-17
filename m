Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYJQFY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYJQFY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYJQFYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:24:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49279
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbYJQFYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:24:49 -0400
Date: Thu, 16 Oct 2008 22:24:25 -0700 (PDT)
Message-Id: <20081016.222425.156677643.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: torvalds@linux-foundation.org, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1224219627.7654.80.camel@pasglop>
References: <20081016.210404.151891223.davem@davemloft.net>
	<alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
	<1224219627.7654.80.camel@pasglop>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 17 Oct 2008 16:00:27 +1100

> As for the 36 bits trick of sparc32, I'll let DaveM do another arch hack
> in there for now until he sorts it out.

Don't sweat sparc32, I'll convert it over to a 64-bit resource_size_t
eventually so for now just printing the 32-bit parts is not a disaster.
