Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbYHSLOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbYHSLOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYHSLNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:13:49 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:6583 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYHSLNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lN1ApKaTLpgj0ariXkJoMBEp3s8pzryeFQlpT1D1wggG9XYqPLPgmnJ3HX5rWaa3yG
         Yq2Zhv6SdEUXQlDZwDwaKw3RbCZo65m5GbeV7wBMmqgQzAJLtpNcT07Anj6vUlExbtKt
         IuAARDtGxNKsc6YIGIF2T3/1bhxUj+K/6+xzU=
Message-ID: <bc64b4640808190413o151cfb8x7809f0e08d1f7aaa@mail.gmail.com>
Date: Tue, 19 Aug 2008 15:13:47 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make gpiochip label const
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net
In-Reply-To: <20080819014305.44a1f9b8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218573588-25528-1-git-send-email-dbaryshkov@gmail.com>
	 <20080812220619.D2011362B0F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <20080817190035.GA29170@doriath.ww600.siemens.net>
	 <20080819014305.44a1f9b8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/19 Andrew Morton <akpm@linux-foundation.org>:
> On Sun, 17 Aug 2008 23:00:35 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>
>> On Tue, Aug 12, 2008 at 03:06:19PM -0700, David Brownell wrote:
>> > > From dbaryshkov@gmail.com  Tue Aug 12 13:54:29 2008
>> > > From: Dmitry Baryshkov <dbaryshkov@gmail.com>
>> > > To: linux-kernel@vger.kernel.org
>> > > Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
>> > >   David Brownell <dbrownell@users.sourceforge.net>
>> > > Subject: [PATCH] Make gpiochip label const
>> > > Date: Wed, 13 Aug 2008 00:39:48 +0400
>> > >
>> > > Mark gpiochip label as a const char pointer.
>> > >
>> > > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>> > > Cc: David Brownell <dbrownell@users.sourceforge.net>
>> >
>> > Acked-By: David Brownell <dbrownell@users.sourceforge.net>
>> >
>>
>> Sorry to disturb, but will this make into 2.6.27-rc? Thanks.
>>
>
> Ordinarily it would not.  Is there some reason why you think it should?
>

It fixes lots of warnings (one per each instance of code filling the gpio chip)
and is pretty much small to honour inclusion IMO

-- 
With best wishes
Dmitry
