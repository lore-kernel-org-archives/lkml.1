Return-Path: <linux-kernel-owner+w=401wt.eu-S1763159AbYCGJgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763159AbYCGJgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbYCGJgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:36:13 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:56231 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYCGJgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GBg1z4gKii67U+kyA4oQUVCzCYXy3GL+HB/F8o6jUiI2RbGbpFZ1o3EdERNu2g4vDqaUd8djBBFrEf/f2WIkn4iiSYPr1fP/u4sdEx491ei6ksX+xVcFYFImC6iu+AU8GX7qnbUTn5nYCwizBdGb7DhlVugAwHpBB15XCX8NKOc=
Message-ID: <a8e1da0803070136h2403edb5kad27f148f01b0c41@mail.gmail.com>
Date: Fri, 7 Mar 2008 17:36:09 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] add time_after_now and other macros which compare with jiffies
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080307012244.ed7625ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080307030901.GA4375@darkstar.te-china.tietoenator.com>
	 <20080307010228.de6700b5.akpm@linux-foundation.org>
	 <a8e1da0803070112p6a5e076aw569a50a69de91504@mail.gmail.com>
	 <20080307012244.ed7625ec.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2008 at 5:22 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 7 Mar 2008 17:12:29 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
>
>  > Indeed, I will add proper comment before them.
>
>  Sob.  Of the 809 usages of time_after(), it appears that over 700 are
>  comparing with jiffies.  So with your (good) change, someone will get
>  buried in well-meaning convert-to-time_after_now patches.


Yes, there will be a lot of patches.  Hope I have that time to do some.

>
>  I wonder who that might be?
>
