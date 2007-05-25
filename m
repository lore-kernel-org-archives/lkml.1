Return-Path: <linux-kernel-owner+w=401wt.eu-S1765663AbXEYVO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765663AbXEYVO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbXEYVOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:14:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47541
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754042AbXEYVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:14:19 -0400
Date: Fri, 25 May 2007 14:14:21 -0700 (PDT)
Message-Id: <20070525.141421.73699719.davem@davemloft.net>
To: satyam.sharma@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: double exclamation (!!) suckage in the kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Satyam Sharma" <satyam.sharma@gmail.com>
Date: Sat, 26 May 2007 01:53:59 +0530

WHat is with multiple people asking about "!!" all of a
sudden today?

> Are all these occurrences merely the debris of
> s/something/!notsomething/g kind of patches or is there some
> dark, unknown C / gcc wizardry I have absolutely no clue of?

"!!" is used in contexts where pointers might be being
tested as well as plain integers, the "!!" turns a pointer
into the equivalent integer boolean for testing.

NULL pointers become 0
non-NULL pointers become 1
