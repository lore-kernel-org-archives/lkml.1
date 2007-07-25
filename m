Return-Path: <linux-kernel-owner+w=401wt.eu-S934291AbXGYRpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbXGYRpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765776AbXGYRpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:45:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28786 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764854AbXGYRo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=gVQX4CvFM1BjBiepJGte0GzDPGCjC6RzDBwLnLLu0FktOdc02mhktJu1SpcnemYbeuc6wdpcZ+8eMVwvLdHTPWGUeu6V3YkBtwfo8u2lQ+ZeQr6a4I4e/1isSs1J6uA+wTnD1ZhOot2smGOxik0L78sH+0ZdGKwlGhTLzVVdFxE=
Date: Wed, 25 Jul 2007 21:44:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: BUG_ON in kmap_atomic_prot()
Message-ID: <20070725174451.GD7811@cvg>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070723183839.GA5874@martell.zuzino.mipt.ru> <20070723190152.GA5755@martell.zuzino.mipt.ru> <20070723132431.42afbae8.akpm@linux-foundation.org> <1185271269.6479.7.camel@Homer.simpson.net> <20070724092839.f0556948.akpm@linux-foundation.org> <alpine.LFD.0.999.0707241124220.3607@woody.linux-foundation.org> <20070724200528.GA5814@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724200528.GA5814@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexey Dobriyan - Wed, Jul 25, 2007 at 12:05:28AM +0400]
| On Tue, Jul 24, 2007 at 11:25:22AM -0700, Linus Torvalds wrote:
| > On Tue, 24 Jul 2007, Andrew Morton wrote:
| > > I guess this was the bug:
| >
| > Looks very likely to me. Mike, Alexey, does this fix things for you?
| 
| Yeah, box is running for more than hour, survived LTP, gdb testsuite,
| portage sync and so on.
| 
| What new to me is that someone decided TSC is unstable but that's
| probably OK on full debug kernel:
| 
| 	Clocksource tsc unstable (delta = 91724418 ns)
| 	Time: pit clocksource has been installed.
| 

Hi Alexey,

actualy I've tsc unstabled even with 2.6.21.3 ;)
Someone think that is 'cause of dynamic clock speed
changing

	http://ussg.iu.edu/hypermail/linux/kernel/0707.1/0873.html

		Cyrill

