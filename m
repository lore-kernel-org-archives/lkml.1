Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbXE2F4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbXE2F4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 01:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXE2Fzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 01:55:53 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:38024 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXE2Fzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 01:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Or9YhHCohGfaIiuWD4UIajcu7Q2H6hyII9dy3yOaL56qUKWJBzbcTqcrNhhXtZVZTvYloS/yetwN/Nbxfwx7V9wuZnM1CQzQpD5XxTRtp+VMRRGSc5tKl44b1gDhX+XwZBzneBt2ZGU3yKjYItiO/9fNYxDm7cI94HjriW+UJPo=
Message-ID: <4cefeab80705282255j7757905aia7b45ea5eddf5f5f@mail.gmail.com>
Date: Tue, 29 May 2007 11:25:52 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <20070528171115.GQ3899@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
	 <200705281049.48679.dhazelton@enter.net>
	 <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com>
	 <20070528154346.GO3899@stusta.de>
	 <4cefeab80705280903t6b2bb687g4eb1d9de2717f6ec@mail.gmail.com>
	 <20070528171115.GQ3899@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Mon, May 28, 2007 at 09:33:32PM +0530, Nitin Gupta wrote:
> > On 5/28/07, Adrian Bunk <bunk@stusta.de> wrote:

<snip>

>
> I have not seen any explanations:
> - Why did the upstream author write the code that way?
> - Why are your changes correct?
> - Why do your changes allow the compiler to produce faster code?
>
> The upstream author of the code is available - and he might be able to
> help you getting answers. No matter whether your changes are incorrect
> or correct optimizations that should go upstream, in both cases
> discussing these issues with upstream is the best solution.

The changelog I posted along with patch mentions all the changes I
made. I thought we will find all problems with this changelog in hand
and considering that its  just ~500 LOC.   But still, ok, asking
author himself will be good if he replies. I will mail him detailed
changelog and seek his feedback on this. This should answer all of
your questions.

>
> And testing is nice, but if you broke some case that's outside of your
> tests you'll never notice.
>

Yes. We cannot come up with exhaustive set of test cases to cover all
cases. But assuming that _original_ version is right and taking the
chagelog we should be able to verify if the porting is correct.


- Nitin
