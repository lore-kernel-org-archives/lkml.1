Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYFHTrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYFHTrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 15:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYFHTqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 15:46:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:53925 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYFHTqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 15:46:54 -0400
In-Reply-To: <jeod6b25ln.fsf@sykes.suse.de>
References: <20080608094730.GA30098@uranus.ravnborg.org> <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com> <20080608104122.GA10545@uranus.ravnborg.org> <1212922141.32207.495.camel@pmac.infradead.org> <20080608111707.GB10545@uranus.ravnborg.org> <1212931024.32207.546.camel@pmac.infradead.org> <2ccd2be2a739abf56d86266d5041bf07@kernel.crashing.org> <jeod6b25ln.fsf@sykes.suse.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <443677aecf2a9bfcb7fb8bb0fa1d71b5@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: geert@linux-m68k.org, Linus Torvalds <torvalds@linux-foundation.org>,
       zippel@linux-m68k.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] Speed up "make headers_*"
Date: Sun, 8 Jun 2008 21:45:34 +0200
To: Andreas Schwab <schwab@suse.de>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 jun 2008, at 19:34, Andreas Schwab wrote:
>>> Assuming we _don't_ want the ac_ahz member to be included on m68k, 
>>> this
>>> should fix it (is __mc68000__ the right thing to use?)...
>>
>> I think __m68k__ is preferred, it's harder to confuse for one of the
>> tuning symbols (that is, __mc68040__ and friends).
>
> __m68k__ wasn't pre-defined by gcc before 3.4.

Darn, I knew I should have checked the history.  __mc68000__ is
the best thing to use, then, some people still use 3.3 (don't ask
me why).


Segher

