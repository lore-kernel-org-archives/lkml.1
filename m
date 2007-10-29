Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbXJ2M2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbXJ2M2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXJ2M2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:28:12 -0400
Received: from mx0.towertech.it ([213.215.222.73]:60361 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750870AbXJ2M2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:28:11 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 08:28:11 EDT
Date: Mon, 29 Oct 2007 13:20:20 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: jikos@jikos.cz, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rtc-linux] Re: BUG: lock held when returning to user space
Message-ID: <20071029132020.4731aa01@i1501.lan.towertech.it>
In-Reply-To: <Pine.LNX.4.64.0710280043590.18815@twin.jikos.cz>
References: <472348F6.6050100@googlemail.com>
	<Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
	<1193498921.5648.68.camel@lappy>
	<Pine.LNX.4.64.0710280043590.18815@twin.jikos.cz>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 00:47:15 +0200 (CEST)
Jiri Kosina <jikos@jikos.cz> wrote:

> Yes, but the fact is that is really is invalid use of mutex -- because the 
> mutex owner could become seriously wrong after fork() or sending the 
> filedescriptor through unix socket ... this easily leads to broken 
> situation.
> 
> This seems to have been introduced in e824290e5d ... Alessandro, could you 
> convert this to test_and_set_bit()/clear_bit() semantics instead of a 
> mutex please?

 Hi Jiri,
   I was away for the weekend and just saw the whole discussion
 and your patch and I'm happy to ack it. Thank you very much
 a thanks to Gabriel for the bug report!
 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

