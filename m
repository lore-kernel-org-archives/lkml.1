Return-Path: <linux-kernel-owner+w=401wt.eu-S1423194AbXDXWZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423194AbXDXWZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423167AbXDXWY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:24:58 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:36847 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423192AbXDXWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qjGlOUUo+Z6NG+ncPZo5kJIl0scsjNLvXn89qaWb0m47p01mIuBLgV3UeFgLZB2ZOshOi43xZGxQpGC9v+m+iKZaOGpEVJLV0gJnMddzWxeHfss7MB3frkr5Bei/JLDURk/j+9U/5SdYvKdbDpeGDVBKsoJ+LertZZcRF1CNr9o=
Message-ID: <2c0942db0704241524r46e02657q22141ae07d5296fc@mail.gmail.com>
Date: Tue, 24 Apr 2007 15:24:52 -0700
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Christian Hesse" <mail@earthworm.de>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>, linux-kernel@vger.kernel.org,
       "Con Kolivas" <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20070424212956.GE16457@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070413202100.GA9957@elte.hu> <20070418211632.GA7610@elte.hu>
	 <200704182357.28107.mail@earthworm.de>
	 <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424205416.GA23032@elte.hu> <20070424212956.GE16457@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, Pavel Machek <pavel@ucw.cz> wrote:
> > so, while it's probably apples to oranges, uswsusp seems to be larger,
> > while there's at least one feature that it is missing.
>
> (We are talking "save 100% memory" here).
>
> As I said, that one feature is doable in uswsusp, too. It is 200
> lines. It also makes mm <-> swsusp interaction _way_ more complex, and

Sounds like the perfect reason to put that in kernel space.

Ray
