Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbXDWVNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbXDWVNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbXDWVNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:13:04 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:39596 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbXDWVNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:13:02 -0400
In-Reply-To: <20070423235502.734e6e67@localhost.localdomain>
References: <20070422232658.5f427fd3@localhost.localdomain> <200704222349.42368.arnd@arndb.de> <20070423101427.3a1d4983@localhost.localdomain> <20070423075957.GA22811@infradead.org> <20070423235502.734e6e67@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <44c9a2b88950e3848d2c4e457641eb9b@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pcmcia@lists.infradead.org,
       linuxppc-dev@ozlabs.org, Christoph Hellwig <hch@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH][RFC] PCMCIA support for 8xx using platform devices
Date: Mon, 23 Apr 2007 23:12:58 +0200
To: Vitaly Bordug <vitb@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> That's a horrible argument.  Please do it properly, and let arch/ppc
>> die as it should.  We shouldn't be adding anything to it anymore
>> anyway.
>>
> I understand your point, but we shouldn't trash existing bits either.

Why not?  The things that haven't been ported over yet
obviously are unmaintained.  If we can make the few
remaining board ports in there utterly broken, we
can finally remove arch/ppc/ completely :-)

Since nothing new gets added to arch/ppc/ anymore,
anyone who wants it can get it from an older kernel
tree, no?

[Yes, I'm half joking.  No, not fully.]


Segher

