Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbXHHLJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbXHHLJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXHHLJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:09:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:29209 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXHHLJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:09:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RpTI+PHUUzD5s3wjj1Le0g/IIhQk/2XMa4lAdpiv67vHMl/qUDD9cHeMQYkxMAl64cmehZKtkklX0XwnlP5KvBu2L3dH8sQAQ8ADn7MfDQMq1mWl0mqePLpTUp2zLiw8HPVrYcmyGJxbQHKSWtbrrD9EimNPSbAQAK3D2i5fO4c=
Message-ID: <1a297b360708080409tfc9dee5mb92c216919bffc1e@mail.gmail.com>
Date: Wed, 8 Aug 2007 15:09:14 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] msleep() with hrtimers
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <p73ps1ys0jz.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15327.1186166232@lwn.net>
	 <20070807124009.9f6c2247.akpm@linux-foundation.org>
	 <p73ps1ys0jz.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08 Aug 2007 13:55:28 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> >
> > I'd be surprised if there was significant overhead - the maximum frequency
> > at which msleep() can be called is 1000Hz.  We'd need an awful lot of
> > overhead for that to cause problems, surely?
>
> The bigger risk is probably to break drivers that rely on msleep(1)
> really being msleep( very long depending on HZ )
>
> But the only way to find out is to try it.

Well, i am quite sure a lot of drivers will be broken. But well .. if
it is for the better, guess, never mind ...

Manu
