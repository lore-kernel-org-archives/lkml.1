Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbZCXOr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbZCXOr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbZCXOra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:47:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48563 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760597AbZCXOr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:47:29 -0400
Message-ID: <49C8F24D.6000603@zytor.com>
Date: Tue, 24 Mar 2009 07:46:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@MIT.EDU>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 0/4] Add support for compiling with -ffunction-sections
 -fdata-sections
References: <1237872525-31014-1-git-send-email-tabbott@mit.edu> <20090324170700.6029f6ce.sfr@canb.auug.org.au> <alpine.DEB.1.10.0903240210410.21037@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0903240210410.21037@vinegar-pot.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott wrote:
> 
> Yeah, unfortunately, because people are always modifying the kernel's 
> "magic" sections, a version of the patch that applies to master will 
> basically always conflict with something in linux-next (at least, this has 
> been my experience updating it during the 2.6.29 release cycle).  As Rusty 
> Russell said last month about this patch, there's no good time for this 
> kind of change.
> 

"Just before -rc1" is pretty much the only time to do this kind of 
changes.  It's not the first time we have had this issue.

	-hpa

