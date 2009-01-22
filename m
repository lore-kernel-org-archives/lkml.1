Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZAVQNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZAVQNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 11:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZAVQNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 11:13:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:18490 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZAVQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:13:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=O4N8CYnxS8yjVOFlikM3AmAnLd8P5DEETLwkdEJM5cMIXNlKm8w9RK6405T0bHhbhb
         dM8skuNytrDZT1Wb/A4PCueNCc7ch1jdTC6rGG/QGDoAtMCtyJVHAVYLoPRnGSI3lGyF
         E10oAiVaRlqvEE7ljPfgtoLZL2LzLS5yTIddE=
Date: Fri, 23 Jan 2009 00:12:57 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [Patch] uml: fix a link error
Message-ID: <20090122161257.GG9732@hack.private>
References: <20090115194033.GA10926@hack.private> <200901170328.15178.rob@landley.net> <20090118083237.GA3292@hack.private> <200901181729.31682.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901181729.31682.rob@landley.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 05:29:30PM -0600, Rob Landley wrote:
>On Sunday 18 January 2009 02:32:37 Américo Wang wrote:
>> >The result panics (twice) and exits, instead of giving me a shell prompt.
>> >Built and run on stock Ubuntu 8.10.  (I posted about it on tuesday, but
>> > nobody replied...)
>>
>> Hi, Rob.
>>
>> I tried what you said, it works very fine here, on my Fedora 10.
>> Could you please tell us which kernel your host is using?
>
>Ubuntu 8.10 stock kernel, calls itself "2.6.27-9-generic".
>
>> and the guest?
>
>Checking tuesday's bug report, it said:
>
>> Linux version 2.6.28 (landley@driftwood) (gcc version 4.3.2 (Ubuntu 
>> 4.3.2-1ubuntu11) ) #6 Tue Jan 13 01:54:34 CST 2009
>
>It's the vanilla tarball (albeit extracted from source control according to 
>the v2.6.28 tag rather than downloaded).

I will try 2.6.28.

>
>Possibly a gcc 4.3 issue?

I don't know. :)

-- 
"Against stupidity, the gods themselves, contend in vain."

