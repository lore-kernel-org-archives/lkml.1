Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZCEQEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZCEQEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZCEQEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:04:35 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:3191 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZCEQEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:04:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Wi5Ko1omdQvSjTgKjhADKSofu9wJ+MoTcZFCq96JLIOQrA++HqwgotoxxyhMEKJXTz
         N4iFAQcnu+ysVxXWl3zlXgLUtP5PZ+KzAnF5FYIzBuK6VX84IN2iyrcOTpnigqBFc+aQ
         2DZOdI3UJnNrRH/owh2qFEH+7moU4Dp4a5RsU=
Date: Fri, 6 Mar 2009 00:04:47 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: um: WARNING: vmlinux: 'memcpy' exported twice. Previous export
	was in vmlinux
Message-ID: <20090305160447.GB4265@hack.private>
References: <49AFC206.9080004@panasas.com> <20090305130610.GA4265@hack.private> <49AFD780.8080500@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49AFD780.8080500@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 03:45:36PM +0200, Boaz Harrosh wrote:
>Américo Wang wrote:
>> On Thu, Mar 05, 2009 at 02:13:58PM +0200, Boaz Harrosh wrote:
>>> On today's linus v2.6.29-rc7-3-g559595a
>>>
>>> Doing make ARCH=um defconfig & make ARCH=um
>>> give's me:
>>>
>>> LD vmlinux.o
>>> MODPOST vmlinux.o
>>> WARNING: vmlinux: 'memcpy' exported twice. Previous export was in vmlinux
>>>
>>>
>>> Sorry if this is a duplicate report
>>>
>> 
>> Weird...
>> I tried to compile like what you said, I can't reproduce it.
>> 
>> Which gcc are you using?
>> 
>> Thanks.
>> 
>
>$ gcc --version
>gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
>
>I'm running on an x86_64 Fedora10 system (updated recently)
>$ uname -o -s -r -m -p -i
>Linux 2.6.27.15-170.2.24.fc10.x86_64 x86_64 x86_64 x86_64 GNU/Linux
>

I am using the same thing, but on i386. I still can't reproduce it. :(

-- 
Do what you love, f**k the rest! F**k the regulations!
 
