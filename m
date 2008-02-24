Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYBXQ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYBXQ3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYBXQ3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:29:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:27446 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYBXQ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:29:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=feCnKjeFT4bOZ0/zsYM5Vu4ZIJs3FyUCjZZPwc2AqcDeRm81+JmI+Wt7ZPkKMLtpcpcnz1SfCMOLvlXc0ddVR45sbeDIVm7r4Sgc+ejBvX5oLrJItdkBd/Jq+Y2cV97xCEmxZYFEX07LzbADtVJPRqF6weHiHAvv14plyvKrM20=
Date: Sun, 24 Feb 2008 18:26:53 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, lguest@ozlabs.org,
       akpm <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [BUG + PATCH/Bugfix] x86/lguest: fix pgdir pmd index
	calculation
Message-ID: <20080224162653.GA30364@ubuntu>
References: <20080224155515.GA24831@ubuntu> <20080224161814.GA29556@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224161814.GA29556@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 05:18:14PM +0100, Ingo Molnar wrote:
> 
> * Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> 
> > I am not sure why the division over four existed in the first place. 
> > It seems bogus, maybe the Xen patch just made the problem appear ?
> 
> i think so - nice detective work and nice fix!
> 

Thanks!. Your turn-around time is super, which is so nice too ;).

> I've picked up your patch into x86.git#testing (until Rusty picks it 
> up), you can track it the following way:
> 
>     http://people.redhat.com/mingo/x86.git/README
> 
> it has other lguest fixes as well - could you double-check that 
> x86.git#testing works fine for you as-is? (i've just updated the git 
> tree so it includes your fix as well)
> 

Ofcourse. I'll send you the results by GMT night.

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

