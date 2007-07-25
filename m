Return-Path: <linux-kernel-owner+w=401wt.eu-S935345AbXGYT2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935345AbXGYT2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759659AbXGYT2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:28:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59826
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbXGYT2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:28:23 -0400
Date: Wed, 25 Jul 2007 12:28:22 -0700 (PDT)
Message-Id: <20070725.122822.92554727.davem@davemloft.net>
To: jeremy@goop.org
Cc: torvalds@linux-foundation.org, hpa@zytor.com, kaos@ocs.com.au,
       xyzzy@speakeasy.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
From: David Miller <davem@davemloft.net>
In-Reply-To: <46A781A4.40103@goop.org>
References: <20070724.232914.56812376.davem@davemloft.net>
	<alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org>
	<46A781A4.40103@goop.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Wed, 25 Jul 2007 10:00:20 -0700

> No, not any more.  The file and line info is out of line, in a separate
> section, indexed by the ud2a's eip.  The main problem with
> __builtin_trap is that there's no certain way to get the actual ud2a eip
> (ie, paste an asm label onto it).

Yes, I tried very hard to accomplish this myself, it would be
wonderful if it could be made to work.  I tried tricks using __label__
in inline asm, everything.

It would be workable if condition codes could be passed into inline
asm statements somehow, or the address of the builtin_trap() could
be reliably obtained.
