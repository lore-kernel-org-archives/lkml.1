Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYEMEjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYEMEjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYEMEjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:39:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55618
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753655AbYEMEja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:39:30 -0400
Date: Mon, 12 May 2008 21:39:25 -0700 (PDT)
Message-Id: <20080512.213925.193699728.davem@davemloft.net>
To: drepper@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/18] flag parameters: check magic constants
From: David Miller <davem@davemloft.net>
In-Reply-To: <48291749.1060400@redhat.com>
References: <482910FA.1080703@redhat.com>
	<20080512.210225.167924945.davem@davemloft.net>
	<48291749.1060400@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Mon, 12 May 2008 21:21:29 -0700

> Is MIPS really a problem?  The value is 0x80.  128 protocol types should
> be enough.  Even if not, there is no reason why the numbers should be
> consecutive.  It's easy enough to skip over a bit.  I.e., after procotol
> 0x7f the next one would be 0x100.

Indeed, MIPS looks good.

> And PA seems to have gotten O_NONBLOCK wrong.  SPARC does it right AFAICS.

I agree.

But that value is compiled into every parisc binary out there,
limiting what we can do about it in the short term.
