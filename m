Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbZAGP3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbZAGP3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZAGP3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:29:02 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:64683 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbZAGP3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=txQ85CVNrJHpbXYxLV1IfrS+1pzeL6c+s/0oQ5xeRI6aciZPj2U8EnFCdpIsYV+lsR
         bqBudf7jpI68//WST/JwDXGm7iqbeTNY3tlvKjEx0gxSdEiHpyBjEApzdL1fmgVAtzCD
         xvr7/YtilYgCBRF3H8BCRxRh10TXRGgjgrqlA=
Message-ID: <4964CA37.4010503@gmail.com>
Date: Wed, 07 Jan 2009 07:28:55 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [ 286.547348] BUG: unable to handle kernel paging request at
 6b6b6b6b
References: <4963F368.7080909@gmail.com>	 <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com>	 <84144f020901070030k6fb888f6n84255078e4885d28@mail.gmail.com>	 <20090107091534.GA4633@osiris.boeblingen.de.ibm.com>	 <1231319946.14720.7.camel@penberg-laptop>	 <b6a2187b0901070336u1cb0bc94i1e47a68d8ea671c@mail.gmail.com>	 <20090107122728.GB4633@osiris.boeblingen.de.ibm.com> <b6a2187b0901070551r5bb86dbfye96c2c92e7b78087@mail.gmail.com>
In-Reply-To: <b6a2187b0901070551r5bb86dbfye96c2c92e7b78087@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On Wed, Jan 7, 2009 at 8:27 PM, Heiko Carstens
> <heiko.carstens@de.ibm.com> wrote:
>   
>> On Wed, Jan 07, 2009 at 07:36:57PM +0800, Jeff Chua wrote:
>>     
>>> On Wed, Jan 7, 2009 at 5:19 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>>       
>>>> On Wed, 2009-01-07 at 10:15 +0100, Heiko Carstens wrote:
>>>>         
>>>>> I missed to convert disable_nonboot_cpus to
>>>>> stop_machine_create/destroy.
>>>>> So it's a use before-even-allocated bug.
>>>>> The patch below should hopefully fix it:
>>>>> Subject: [PATCH] cpu hotplug: add stop_machine_create/destroy to disable_nonboot_cpus
>>>>>           
>>>> Looks good to me!
>>>>         
>>> This also fixes the suspend-to-ram/disk problem. Without it, the
>>> system will just hang.
>>>       
>
>   
>> Did you also see the reboot problem and does the patch fix it for you?
>>     
>
> I never had problem with rebooting. Just suspend hanging which is
> really annoying ... walking away and come back hours later and
> realized that the suspend is hanging and having to do a hard boot.
>
> Thanks,
> Jeff.
>
>   
Man!!  I missed this whole conversation
(passed out, too tired);
I'll go ahead and apply the patch and let you
know If I get the freeze at shutdown.
Then I'm still interested in knowing
how to take a debug messages and dissect
it to find the exact location of the problem.
(but could do that later);

regards;

Justin P. Mattock
