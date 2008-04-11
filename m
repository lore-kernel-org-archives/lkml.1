Return-Path: <linux-kernel-owner+w=401wt.eu-S1761325AbYDKS0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325AbYDKS0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760162AbYDKS0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:26:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39495
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760070AbYDKS0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:26:31 -0400
Date: Fri, 11 Apr 2008 11:26:31 -0700 (PDT)
Message-Id: <20080411.112631.218741504.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org, roland@redhat.com,
       heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH] reorganize <linux/linkage.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0804110747370.3143@woody.linux-foundation.org>
References: <20080411050019.GC27073@phobos.i.cabal.ca>
	<alpine.LFD.1.00.0804110747370.3143@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 11 Apr 2008 07:58:56 -0700 (PDT)

> I'm starting to suspect that it's the fact that some architectures still 
> have
> 
> 	EXTRA_AFLAGS  := -traditional
> 
> or equivalent and I'm wondering whether that is really necessary. IIRC x86 
> got rid of the use of --traditional a long time ago, exactly because it 
> caused problems with any fancier C preprocessor things.

A lot of it is probably simply copy and paste from other ports.

When I removed it from Sparc long ago, the only issue I had was that
there were some things using "/**/" concatenation in some sparc
assembler CPP macros, and those were easily fixed.
