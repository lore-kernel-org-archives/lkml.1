Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbZJUFno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbZJUFno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 01:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZJUFno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 01:43:44 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:37500 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbZJUFnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 01:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AKgSZwcwoP8e7mjde6jGqOYy2k8WvkEPHQqwQB740zZ76hWuMZJ1AdPWZex8dD/I+f
         ZXz0IEp9DyJ68ydA3Q+vireYyrxdhp8rgIpgV3IjTk3ybkfo+iyS74+qGJ5vSq3ulS6L
         Q4e4znkGqdiAz/iW+Ktxgos99v7xoJfeswXwM=
Message-ID: <4ADE9F90.8060608@gmail.com>
Date: Tue, 20 Oct 2009 23:43:44 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Carmelo Amoroso <carmelo73@gmail.com>
CC: Greg KH <greg@kroah.com>, Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Fast LKM symbol resolution with SysV ELH hash table
References: <4ADACD3A.9020803@gmail.com>	 <9b2b86520910180544g94ecc8fuf0d7849e18cd8937@mail.gmail.com>	 <20091018214704.GA26592@kroah.com>	 <2ccd6e3c0910190445va8ff4a8x94dc4044ac01057d@mail.gmail.com>	 <20091019132205.GA7192@kroah.com> <2ccd6e3c0910190802w117f8ac1nb562214786904c04@mail.gmail.com>
In-Reply-To: <2ccd6e3c0910190802w117f8ac1nb562214786904c04@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2009 09:02 AM, Carmelo Amoroso wrote:
> 2009/10/19 Greg KH<greg@kroah.com>:
>> On Mon, Oct 19, 2009 at 01:45:20PM +0200, Carmelo Amoroso wrote:
>>> Just a few other notes. The current implementation I did based on SysV
>>> has a drawback that is not backward compatible, so you cannot use old
>>> modules with a kernel with the option enabled due to changes on struct
>>> kernel_symbol.
>>
>> Why would this be a problem?  Whenever making a kernel config change,
>> you should be able to rebuild everything, as lots of other configuration
>> options are that way.
>>
>
> This is not always true... there could be cases in which you cannot
> recompile old modules
> (e.g vendors that provide non GPL modules)

Even non-GPL modules can normally be rebuilt as far as the module format 
is concerned, there's usually an object file blob that gets compiled 
into a module on install or something, like the Nvidia graphics driver. 
If anyone's providing binary-only fully built modules (which would be 
inherently tied to one exact kernel version and one configuration) they 
really need to have their head examined..
