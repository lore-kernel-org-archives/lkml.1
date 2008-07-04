Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYGDLcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYGDLcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 07:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYGDLcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 07:32:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:39530 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYGDLcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 07:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RVeqIUAGMHdbqSF5BVv9hWbiEx+KpgsPfs+ofx5nWGlk2W1yMTopwDeoHq33yLkuxA
         wBQhEVN/V/rtex0YVbi71ZgAcyfiuZ4kDRpUBSkGmK9sWXz+5HEbV3Qp2Ekq5lFjj7QY
         EFL3gxG0xcuNjG0WlF7jdDx5NnwN2uZZcvQEM=
Message-ID: <486E0A64.5020903@gmail.com>
Date: Fri, 04 Jul 2008 15:32:52 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: dsdt buggy acpi
References: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com>	 <200807011619.53339.rjw@sisk.pl>	 <dd18b0c30807010918p48cfbe2bnb7e4a2bf00a01638@mail.gmail.com>	 <20080702082555.0959ef2b@linux360.ro>	 <20080702100935.GA699@srcf.ucam.org>	 <20080702144820.29f7d43d@linux360.ro>	 <20080702115527.GA3396@srcf.ucam.org>	 <dd18b0c30807020930u43405fd5v2e328b6b76b833b0@mail.gmail.com>	 <20080702163510.GA8912@srcf.ucam.org> <dd18b0c30807021037g3faffa6kd1ef26f888f36d11@mail.gmail.com>
In-Reply-To: <dd18b0c30807021037g3faffa6kd1ef26f888f36d11@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> On Wed, Jul 2, 2008 at 4:35 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>   
>> On Wed, Jul 02, 2008 at 04:30:11PM +0000, Justin Mattock wrote:
>>
>>     
>>> Hello; what info is supplied with EFI i.g. I'm using a macbook pro.
>>> After looking at:
>>> http://acpi.sourceforge.net/dsdt/view.php I was unable to locate
>>> anything with apple, or at least
>>> couldn't find the manufacture number.
>>> If somebody has already done this, I was wondering if it would be O.K.
>>> if I can attached my dsdt.dsl with the errors,
>>> and my explanation of what I changed, just so If I did something
>>> completely wrong
>>>       
>> iasl will complain about code that the Linux interpreter will happily
>> accept. If the only reason you've made changes is that iasl complains,
>> then it's unlikely that there's any functional difference as a result.
>> Otherwise, work out which changes fix which Linux bugs and file a bug
>> at bugzilla.kernel.org against acpi.
>>
>> --
>> Matthew Garrett | mjg59@srcf.ucam.org
>>
>>     
>
> Hello; I modified dsdt because iasl was complaining, As a result like
> what you said
> "then it's unlikely that there's any functional difference as a
> result" is probably
> what I'm seeing. As for a bug report I already have one filed. As to
> why I'm messing with
> the dsdt, just trying to isolate the problem with the bug I have
> already filed., or at least
> get a better idea of what is happening. Anyways thanks for the info.
> regards;
>
>   

For difference, you should look for "Darwin", this is how MacOS X 
identifies itself to hardware.


Regards,
Alex.
