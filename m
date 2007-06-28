Return-Path: <linux-kernel-owner+w=401wt.eu-S1761208AbXF1P15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761208AbXF1P15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbXF1P1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:27:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40548 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbXF1P1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:27:50 -0400
Date: Thu, 28 Jun 2007 17:27:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
Message-ID: <20070628152747.GA14519@one.firstfloor.org>
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com> <1174610594.6598.3.camel@sli10-conroe.sh.intel.com> <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com> <p731wfy5m74.fsf@bingen.suse.de> <4683BD56.7070707@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4683BD56.7070707@tmr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Slashdot carried an article this morning saying that an error in Intel 
> microcode was being fixed. However, it listed only Windows related sites 

That's a little misleading. Always dangerous getting your information
from slashdot. Let's say Intel clarified some corner 
cases in TLB flushing that have changed with Core2 and not everybody
got that right. I wouldn't say it was a Intel bug though.

> for the "fix" download. Is this the same TLB issue? And are these really 

I think so.

> fixes for Windows to flush the TLB properly the way Linux does?

On newer Linux 2.6 yes. On 2.4/x86-64 you would need in theory the microcode 
update too.  (it'll probably show up at some point at the usual place 
http://urbanmyth.org/microcode/).  Linux/i386 is always fine.

But the problem is very obscure and you can likely ignore it too. If your 
machine crashes it's very likely something else.

-Andi
