Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYJNFin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYJNFin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 01:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYJNFif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 01:38:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38106
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbYJNFif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 01:38:35 -0400
Date: Mon, 13 Oct 2008 22:38:11 -0700 (PDT)
Message-Id: <20081013.223811.174710738.davem@davemloft.net>
To: hpa@zytor.com
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: David Miller <davem@davemloft.net>
In-Reply-To: <48F409E9.3030501@zytor.com>
References: <48F3F014.3050406@zytor.com>
	<1223948488.8157.309.camel@pasglop>
	<48F409E9.3030501@zytor.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 13 Oct 2008 19:54:33 -0700

> I pointed out that we should use the flags to determine formatting
> options, e.g. I/O space is only 16 bits on x86.

It's 64-bit on sparc64 :-)

There's also the bit where we use a 32-bit resource_t on sparc32
but encode the top 4-bits of the 36 bit physical I/O address in
the resource flags member.
