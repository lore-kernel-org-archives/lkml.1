Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZLFDgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZLFDgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 22:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZLFDg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 22:36:27 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38829 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbZLFDg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 22:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ezllcLgnOuOMX9mnvKN/kNqs5nO5a3FJvZ/rzzYgmBIOBhhfII3wtvMDBgf63O3jvx
         cUEJwps5MQZl/5YXezJEeCEGLrBT3kpgkwzg4wZpjm2bzzD2RBTwOcs45F8uh9jFHwPw
         Hwp2RIxatVm+980Arrw49ZctsWXqPPtc2kQvQ=
Message-ID: <4B1B26B6.2060506@gmail.com>
Date: Sat, 05 Dec 2009 22:36:22 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Brice Goglin <brice@myri.com>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next-2.6] drivers/net: Move && and || to end of previous
 line
References: <1259001504.16503.79.camel@Joe-Laptop.home>	 <20091123.104130.117837098.davem@davemloft.net>	 <1259528449.29779.194.camel@Joe-Laptop.home>	 <20091129.165557.84377714.davem@davemloft.net>	 <1259863101.22783.63.camel@Joe-Laptop.home>  <4B190A29.5080905@myri.com>	 <1259947271.22783.120.camel@Joe-Laptop.home>  <4B1A557D.4080707@gmail.com> <1260035440.11126.50.camel@Joe-Laptop.home>
In-Reply-To: <1260035440.11126.50.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sat, 2009-12-05 at 07:43 -0500, William Allen Simpson wrote:
>> My main objection to these sweeping patches is that it makes it much
>> more difficult to maintain and apply patches across different versions of
>> the tree.
> 
> I think you underestimate the value of
> standardization and overestimate the
> quantity of work to sort it out for
> the -stable versions.
> 
As I mentioned to somebody in private email (having kept rough track), it
took around 9 hours this week for my 8 patch series, spread over 3 days
because of the tedium.  Fix rejects, visually check patch against previous
version, compile, test -- at least 1/2 to 1 hour for each numbered patch.
Plus time to resubmit the patch series to the list again.

Of course, that was only for the initial patches already posted to the
list.  I've many more -- awaiting approval for the previous set....

Eventually, I have to do the same for each supported -stable version.

Multiply by thousands of contributors.

Hopefully, you did the same, carefully checking your regexp generated
patches visually line by line, and compiling, and testing every driver
in this large patch individually.

I'm not a big believer in making trivial formatting changes and assuming
they work.  Or that I didn't fumble fingers somehow.  I've made many such
stupid mistakes over the years.
