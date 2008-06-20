Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYFTLkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYFTLkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYFTLkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:40:11 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:43588 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYFTLkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:40:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IVczzNaDyqUGzWLd5+8eg6tMgVrNvQZZIa05nw2zj6/4CvPGqyP/S5lP5azdn6/zGd
         bs4u5brWGvzSf3Xlg+TtxwWBC2azoL84PfoMabD04Oq37QqvdCXLPrAoLIR8B+nvZDjs
         bldluYRFOs7dohVF6yngeL7H68hAG3c6KpJCo=
Message-ID: <d1af83620806200440g3bdbff03va0883b2ddb6f0ddb@mail.gmail.com>
Date: Fri, 20 Jun 2008 08:40:07 -0300
From: "Kevin Winchester" <kjwinchester@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: Bisecting tip/auto-x86-next?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Ingo Molnar" <mingo@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080620104934.GA22326@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485AFC9B.7090502@gmail.com> <20080620101722.GD17692@elte.hu>
	 <20080620104934.GA22326@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 7:49 AM, Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
>> * Kevin Winchester <kjwinchester@gmail.com> wrote:
>
>> > Hi,
>> >
>> > I am trying to track down a problem I reported here:
>> >
>> > http://lkml.org/lkml/2008/6/11/431
>
> Can you try iommu=memaper=2 ?

I should have mentioned that in the original post - I tried
iommu=memaper=2, and got the identical result (including the message
asking me to try iommu=memaper=2).  Perhaps the message should not be
printed if the user did actually provide that boot option.

>
> Is it amd64 machine?

Yes it is, UP.

Thanks,

-- 
Kevin Winchester
