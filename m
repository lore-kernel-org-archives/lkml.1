Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbYC0NeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbYC0NeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762220AbYC0Ndy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:33:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:5525 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762203AbYC0Ndw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GBKJ6k0CDrFxwH1owLEqRwFTsitpkaQaCB2l1vuDk92yGVzRhQ0YW9oaTXxDSJVStZ26KZ11PJRnROxYYICb6OczTcBQBxLC+RCMP1zek0W85GWVE5TzIMLoSudY3FVtrCACkei2Jykb9VJUknW2kx+5iZqH4M1XpQ3k2T4V9Pw=
Message-ID: <bc64b4640803270633t3b862405sb2708eee25708868@mail.gmail.com>
Date: Thu, 27 Mar 2008 16:33:51 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Cc: "Russell King" <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com, lethal@linux-sh.org,
       tony@atomide.com, paul@pwsan.com
In-Reply-To: <20080327112048.014200cb@hskinnemo-gx620.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	 <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
	 <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
	 <20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com>
	 <20080327091810.GA32396@flint.arm.linux.org.uk>
	 <20080327102648.225d6b4f@hskinnemo-gx620.norway.atmel.com>
	 <20080327093301.GB32396@flint.arm.linux.org.uk>
	 <20080327105323.28a369fd@hskinnemo-gx620.norway.atmel.com>
	 <bc64b4640803270308w6dc0723dr29e0ce5f20088d6d@mail.gmail.com>
	 <20080327112048.014200cb@hskinnemo-gx620.norway.atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/3/27, Haavard Skinnemoen <haavard.skinnemoen@atmel.com>:
> On Thu, 27 Mar 2008 13:08:37 +0300
>
> Dmitry <dbaryshkov@gmail.com> wrote:
>
>
> > I like this idea! This would also allow to cleanup the references code, etc.
>
>
> Great!
>
>
>  > Also after I saw such refactored struct clk, I thought that it looks
>  > nearly like kobject. Maybe we should switch to the kobject-based
>  > structs? What do you think?
>
>
> I think that would be overkill. We should try to keep this stuff as
>  lightweight as possible, and I'm not sure if we can give the kobject
>  "parent" field the meaning we want it to have...or use the kref thing
>  to do something unrelated to object lifecycle management (i.e. we don't
>  want to destroy the object when the refcount goes to zero, we just want
>  to stop the clock.)

ACK. Then I'll repost the updated patchset later.

-- 
With best wishes
Dmitry
