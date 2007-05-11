Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbXEKJOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbXEKJOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbXEKJOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:14:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50855
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752969AbXEKJOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:14:40 -0400
Date: Fri, 11 May 2007 02:14:43 -0700 (PDT)
Message-Id: <20070511.021443.41636409.davem@davemloft.net>
To: deweerdt@free.fr
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jorge@laser.satlink.net, agulbra@nvg.unit.no
Subject: Re: [-mm patch] make csum_and_copy_from_user arch independent
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070511082738.GA23560@slug>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
	<20070511082738.GA23560@slug>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederik Deweerdt <deweerdt@free.fr>
Date: Fri, 11 May 2007 10:27:38 +0200

> ERROR: "csum_partial_copy_from_user" [net/rxrpc/af-rxrpc.ko] undefined!
> 
> Linking on ARM fails because albeit a generic csum_and_copy_from_user()
> function is provided in the case ! _HAVE_ARCH_COPY_AND_CSUM_FROM_USER, the
> generic function uses csum_partial_copy_from_user() which is i386 only.

On what planet is csum_partial_copy_from_user() i386 only?
Every single platform provides that function.

The issue more-so appears to be that ARM simply fails to
export the symbol to modules like the other platforms do.
