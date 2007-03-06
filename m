Return-Path: <linux-kernel-owner+w=401wt.eu-S934090AbXCFMKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090AbXCFMKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934091AbXCFMKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:10:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:12587 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934090AbXCFMKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:10:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y/W4hxTD+SO7yuMAyZTWm84uAq4XTbV6rXpBLMaBp8fv2WNB1qewlQyIBjSgadFHe7OCqaR2DAKrTt2+4vn1/5cTagZPPsTCFvRMAop6poiPc8Vpe/ZsNy/SbTT4prnz1XkYrKlOypqd4OX4Q8YguOsW1jkRnPy6skdwoQY6UE4=
Message-ID: <b6a2187b0703060409g3ae27f44lf9ff331aea3fa4b3@mail.gmail.com>
Date: Tue, 6 Mar 2007 20:09:58 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Emil Karlson" <jkarlson@cc.hut.fi>, "Len Brown" <lenb@kernel.org>
In-Reply-To: <1173180977.9161.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org>
	 <1173142948.24738.257.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org>
	 <20070306103315.GA4295@mellanox.co.il>
	 <20070306103712.GA10942@elte.hu>
	 <20070306104618.GA5792@mellanox.co.il>
	 <1173180977.9161.14.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Soeren Sonnenburg <kernel@nn7.de> wrote:

> > > > Not yet for me unfortunately, although this seems to help.
> > > > Is this the patch I should have applied?
> > > > http://lkml.org/lkml/2007/3/5/445

Same problem for me on 2.6.21-rc2/rc1 on IBM X60s. I've applied this
patch and Ingo Molnar's patch and s2ram still can't suspend. I tried
turning off CONFIG_KVM as well, but makes no difference.

Will try turning off CONFIG_NO_HZ to see if this makes any difference.
2.6.20 works fine.
Jeff.
