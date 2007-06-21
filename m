Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbXFUNVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbXFUNVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbXFUNVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:21:31 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:8062 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbXFUNVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GpbzhM+LsHrFm9B4NtKxayM864rWzcU/FUKpPLvCHDbkRAaJDkzyQ5GnVdJ2JrpNhfXLFoOT+GjbwDIs7ljnINrA3MLcYDZ6QIqDhQ5sTOH0MN0RIG9Y+/+kl4iBoKaDKJzqrWe7vg0NwO8ronZqs4FzJ9TQrZq/g1eVsFRL60o=
Message-ID: <91b13c310706210621n29a2da43lc5caaf14df2bd47b@mail.gmail.com>
Date: Thu, 21 Jun 2007 21:21:28 +0800
From: "rae l" <crquan@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] trivial: the memset operation on a automatic array variable should be optimized out by data initialization
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4676BBC9.3060707@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467658db.0f98600a.5a55.ffffdd79@mx.google.com>
	 <4676BBC9.3060707@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Denis Cheng wrote:
> > From: Denis Cheng <crquan@gmail.com>
> >
> > the explicit memset call could be optimized out by data initialization,
> > thus all the fill working can be done by the compiler implicitly.
> >
>
> How does the generated code change?  Does gcc do something stupid like
> statically allocate a prototype structure full of zeros, and then memcpy
> it in?  Or does it generate a series of explicit assignments for each
> member?  Or does it generate a memset anyway?
>
> Seems to me that this gives gcc the opportunity to be more stupid, and
> the only right answer is what we're doing anyway.
>
>     J
>
Technically speaking, C standard guarantees the data be initialized correctly;
just from the point view of code style, let the compiler selects how
to initialize will be better, this could let the compiler has more
optimization points.

-- 
Denis Cheng
Linux Application Developer
