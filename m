Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbYGSOxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbYGSOxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 10:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYGSOxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 10:53:36 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:59659 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbYGSOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 10:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Imm7E5a6BkpkElHbEXIC/OZ6Xw3uQl9Owwv9HfXLXuSjmXeenU3PF06lL7tehyq9zF
         USZGBEUXYWFOYGyEGCb/J0H7qiK+R9MmfOScit5Cy0ONa2qmuIz9Axe554VHhHg2s5GP
         6ZcjAgAyDuCkokdFKpjNUk09aU9Mftm7ajVv4=
Message-ID: <dd18b0c30807190753q22259690jcae780de13c8560d@mail.gmail.com>
Date: Sat, 19 Jul 2008 07:53:34 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: macbook2,2 latest git mmconfig issues
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080719131038.GA13168@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com>
	 <86802c440807182145qa3d17e9k210c498109d86b58@mail.gmail.com>
	 <dd18b0c30807182254i49de078bhe5e48ab13e7b01ac@mail.gmail.com>
	 <dd18b0c30807182354h429ea664gb90b7de55608d0bd@mail.gmail.com>
	 <20080719131038.GA13168@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 6:10 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> Justin,
>   I never saw any error messages like that. If you are seeing the
> same problem under 2.6.25 suddenly it might suggest a hardware
> failure, no? That or something else has corrupted on your linux
> volume. What happens if you boot from a linux rescue DVD? Does that
> give the same error?
>                      Jack
>
> On Fri, Jul 18, 2008 at 11:54:38PM -0700, Justin Mattock wrote:
>> applied both patches and messed with boot options
>> but no go:
>> this is what I'm seeing
>> PCI: Fatal no config space access function found
>> ata-piix 0000:00:1f11 device not available
>> because of BAR0 [0xf0-0x1f7] collisions
>>
>>
>> interesting how this kernel was running fine, and then
>> BAM all of a sudden f*&^ed up, This tells me that this was something
>> happening a while ago, or always happening just not
>> noticed i.g. I plugged in 2.6.25-rc9(my favorite)
>> and it too was giving the same response.
>> after tracing back my steps the only application that might be causing
>> this or hiding this is grub but could be wrong.
>>
>> any ideas or patches would be appreciated, until further
>> notice I'll be using osx until there is a
>> regards;   : (
>>
>> --
>> Justin P. Mattock
>

could be; but  loading an iso works i.g.
after installing it and starting up.
these two messages came from after applying
the two patches(keep in mind I was tired so maybe
plugged them in wrong) before the two patches
the MMCONFIG disable message with f0000000
that you where receiving. maybe the manufacture
on mine needs to be MacBookPro2,2 and the 0x3f
needs to be 0x1f. Where do I find these numbers
and names on the system? I've done dmidecode
but can't seem to make out any of the info

-- 
Justin P. Mattock
