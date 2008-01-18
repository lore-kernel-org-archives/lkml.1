Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbYARXrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbYARXrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 18:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbYARXrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 18:47:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:32891 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbYARXrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 18:47:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=La4CzzEzuAg029xkLVMK6Kw5qtMizEQezqS5mYGbTiwuDUZWhi9C6wktza7kwGzaBB8F5X0eAhAU6N0ApQytYUHhOGC2sTVpJIDhBuaQK9Q8UhZRvNsVpogdUlxriO9lMBhWePEig1xFJTl0RqRuNi0S9ELxrLPf4HkJGfTro34=
Message-ID: <47913A72.5040607@gmail.com>
Date: Sat, 19 Jan 2008 08:46:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fischer@norbit.de,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH] SCSI: fix isa/pcmcia compile problem
References: <20080117023514.9df393cf.akpm@linux-foundation.org>	 <478F7F2B.9000801@linux.vnet.ibm.com>	 <20080117111104.3baa878e.akpm@linux-foundation.org>	 <47904927.1040000@linux.vnet.ibm.com>  <47905348.1000709@gmail.com>	 <1200668315.3111.3.camel@localhost.localdomain>	 <479135EE.2090009@gmail.com> <1200699173.3111.77.camel@localhost.localdomain>
In-Reply-To: <1200699173.3111.77.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> I personally think it's a bit odd to disallow building into kernel
>> because of the peculiarity of the implementation (including c files and
>> compiling them slightly differently) and also no one reporting doesn't
>> necessarily mean no one has attempted it and failed.
> 
> Heh ... I'll make you a deal.  Find just one user of one of these
> drivers who can make use of them built in, and I'll apply the patch.  

I don't think I can.  I didn't even know they were isa ones before
actually looking at the code.

> I'm just a bit reluctant to touch these drivers, since they're all
> incredibly ancient.  We don't have good luck with simple transformation
> patches on the older drivers ... and it seems to take months before
> anyone notices there's a problem.

Alright then, please go ahead and disallow built-in.

Thanks.

-- 
tejun
