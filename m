Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZHCBB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZHCBB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbZHCBB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:01:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:37781 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbZHCBBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:01:52 -0400
Message-ID: <4A7636DF.8090201@kernel.org>
Date: Mon, 03 Aug 2009 10:01:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org>	<alpine.LFD.2.01.0907311218080.3161@localhost.localdomain>	<20090731195705.GA12270@elte.hu>	<alpine.LFD.2.01.0908011214330.3304@localhost.localdomain>	<4A7499BA.2000405@zytor.com>	<alpine.LFD.2.01.0908011501470.3352@localhost.localdomain> <19060.59896.983880.446901@cargo.ozlabs.ibm.com> <4A750D66.6050203@zytor.com>
In-Reply-To: <4A750D66.6050203@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 01:01:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

H. Peter Anvin wrote:
> You can't actually do "lea %gs:foo,%rbx" (lea doesn't include the
> segment offset, unfortunately; I asked AMD to change that on 64 bits
> but, not too surprisingly, they weren't able to make that change.)
> Getting the address is expensive, but it's obviously possible -- which
> may have similar bad results.  It would be worth experimenting with a
> little bit, though.

Yeap, this part is strange.  I can't understand why it was done that
way.  Interestingly, the segment override doesn't trigger any
exception, it just gets ignored.  Is there a way to retrieve %gs value
without accessing memory?  ie. other than %gs:identity_gs?

Thanks.

-- 
tejun
