Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbXFNQxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbXFNQxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbXFNQxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:53:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:24081 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXFNQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h41rizRCvgmjbrqwXfzIW/itoRNvuBVPOkJfBH4TwsFF/FYZYPPedCpLuVr9G054oi2Xw/Dw0Sty0dksATy7uu0ExEuS2S6ySZzIBW5rKlxNWFpEMJigyQkIN7w7Ofa8watwkWGYS4qybRnxvj4HjRb2qxWO6OAPnxcxcLaGyJw=
Message-ID: <6934efce0706140953x2167944fr54eca6376e1f8d63@mail.gmail.com>
Date: Thu, 14 Jun 2007 09:53:33 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       linux-kernel@vger.kernel.org,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>
In-Reply-To: <4671495A.3020605@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706121711m738bd9abqa02350ccc7eabf9f@mail.gmail.com>
	 <4671495A.3020605@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> An alternative approach, which does not need to have struct page at
> hand, would be to use the nopfn vm operations struct. That one would
> have to rely on get_xip_pfn.

Of course!  Okay now I'm begining to understand.

> The current path would then be deprecated.

Why?  Wouldn't both paths be valid options?

> If you're interrested in using the later for xip without
> struct page, I would volounteer to go ahead and implement this?

I'm very interested in this.


 I'm not opposed to using struct page, but I'm confused as to how to
start that.  As I understand it, which is not well, defined a
CONFIG_DISCONTIGMEM region to cover the Flash memory would add that to
my pool of RAM.  That would be 'bad', right?  I don't see how to
create the page structs and set this memory aside as different.
