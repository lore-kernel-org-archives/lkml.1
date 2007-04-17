Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXDQHEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXDQHEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXDQHEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:04:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:21030 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXDQHEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bTkx1rAVCMqdUAxde4lEHHbxavxj7Es9ranz9athcp+xAGhCJODVqP+3KnrlSEtYhtinEfJ4wOUgm3/AEOBsyIYvvfPzyFqRyWDqb0Ch/pKmo53YeEDpUkHMb8YZvnxqHPhBrsBLmbkXNF61NfAGWGH6QI4jwdcf689ZgyrLeUA=
Message-ID: <38b2ab8a0704170004h12c4ea41we6bdab3a1b443a18@mail.gmail.com>
Date: Tue, 17 Apr 2007 09:04:30 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: question on generic gpio interface
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200704160646.59407.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704131351la5085vf0ab58e85cf49879@mail.gmail.com>
	 <200704131543.32976.david-b@pacbell.net>
	 <38b2ab8a0704160303l7c550c2dq3b700b2e93d01a7@mail.gmail.com>
	 <200704160646.59407.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, David Brownell <david-b@pacbell.net> wrote:
> No, all of those need to be done.  (Plus maybe a few more things,
> I wasn't trying to be exhaustive.)  That last point is what makes
> the other ones take effect ... without it, the top level IRQ will
> never get dispatched to the GPIO-specific IRQ.
>
> Look at the examples I referenced.
>

I took a deeper look at the examples you mentioned and I understand
what you mean now...

I'm going to implement this since it all makes sense to me now. I'll
give you any feedbacks and try to post questions related to gpio only
if any.

BTW, are there any plan to make gpio usable from userspace ? I don't
know if it makes sense but I saw some patches on LKML that did that.

Thanks again.
-- 
Francis
