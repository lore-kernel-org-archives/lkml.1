Return-Path: <linux-kernel-owner+w=401wt.eu-S932296AbXF1XJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbXF1XJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764858AbXF1XJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:09:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43335 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763876AbXF1XJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:09:16 -0400
Date: Fri, 29 Jun 2007 01:09:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
Message-ID: <20070628230914.GB14519@one.firstfloor.org>
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com> <1174610594.6598.3.camel@sli10-conroe.sh.intel.com> <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com> <p731wfy5m74.fsf@bingen.suse.de> <4683BD56.7070707@tmr.com> <20070628152747.GA14519@one.firstfloor.org> <468434DE.103@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468434DE.103@tmr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I was mainly concerned with this being a new issue, and curious if 
> Microsoft was calling an O/S bug a "microcode fix," given that the 
> average Windows user doesn't know microcode from nanotech anyway. The 
> non-answer from Arjan didn't answer either, and started by calling the 
> report FUD, implying that Slashdot was wrong (not about this), and 
> issuing so little answer and so much obfuscation that I thought he might 
> be running for President. ;-)

Well you can read the Intel documentation if you want the whole story.
You can hardly expect a full introduction in the basics and then
subtle issues of TLB flushing in a quick email.  You asked about opinions 
and summaries and those you got.

> I'd like the microcode update, 

It's called the "placebo effect" in the literature I believe.

> some people elsewhere speculate that user 
> level code could effect reliability if not security. 

speculate is the key word.

> I worry that an old 
> 2.4 kernel would be an issue, even in kvm, if that were the case.

TLB flushing in virtualization works completely different. I doubt
it would be affected.

-Andi

