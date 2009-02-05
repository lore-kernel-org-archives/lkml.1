Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbZBERew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbZBERew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZBERen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:34:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42761 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZBERem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:34:42 -0500
Date: Thu, 5 Feb 2009 18:34:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Brian Gerst <brgerst@gmail.com>,
       Xen-devel <xen-devel@lists.xensource.com>, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: style fascism for xen assemblies
Message-ID: <20090205173430.GA9233@elte.hu>
References: <4983AC87.5000304@goop.org> <498A87B5.3020808@gmail.com> <20090205150028.GD23903@elte.hu> <498B0E13.7060604@gmail.com> <498B226A.2020900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B226A.2020900@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Tejun Heo wrote:
>> Impact: style cleanup
>>
>> Make the following sytle cleanups.
>>
>> * drop unnecessary //#include from xen-asm_32.S
>>   
> Fine.
>> * compulsive adding of space after comma
>>   
> Fine.
>> * reformat multiline comments
>>   
>
> I don't really like what you've done here.  There are two problems:
>
>    * If you're going to convert comments of the form
>
>      /* This is a small comment which
>         happens to be longer than a line. */
>          
>
>      then you should convert it to full winged-style, rather than just
>      sticking '*' on the front of the second line.
>    * All the big block comments look crowded and cramped now, which
>      makes them harder to read and maintain.  All those '*'s are just
>      visual noise. (They make a bit more sense in C code to distinguish
>      comment from code, but asm code looks so different from comment
>      that they're not necessary here.)
>
> But Ingo's already pulled it, so I guess I'm stuck with it.

i pulled it and i already fixed all the proper winged style comments as 
well. Could you double-check the end result please?

	Ingo
