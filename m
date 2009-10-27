Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZJ0SkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZJ0SkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:40:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZJ0SkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:40:01 -0400
Received: from mail.lang.hm ([64.81.33.126]:48310 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652AbZJ0SkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:40:01 -0400
Date: Tue, 27 Oct 2009 11:39:54 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Greg KH <gregkh@suse.de>
cc: "John W. Linville" <linville@tuxdriver.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] strip: move driver to staging
In-Reply-To: <20091027140812.GC17208@suse.de>
Message-ID: <alpine.DEB.2.00.0910271136530.11504@asgard.lang.hm>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com> <20091023161006.GA1580@ucw.cz> <20091026165518.GE2792@tuxdriver.com> <alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm> <20091026184734.GA21591@suse.de> <alpine.DEB.2.00.0910262106050.14994@asgard.lang.hm>
 <20091027140812.GC17208@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Greg KH wrote:

> On Mon, Oct 26, 2009 at 09:17:55PM -0700, david@lang.hm wrote:
>> On Mon, 26 Oct 2009, Greg KH wrote:
>>
>>> On Mon, Oct 26, 2009 at 10:18:20AM -0700, david@lang.hm wrote:
>>>> if someone were to claim 'maintainership' and then do nothing other than
>>>> complain if someone else were to change an API but not fix this in the
>>>> process, how would this be different than the current situation?
>>>
>>> A person "claiming maintainership" would then be responsible for keeping
>>> the API up to date and ensuring that the driver worked.  To do that,
>>> hardware would probably need to be present.
>>
>> actually, I understood that the person changing the API was responsible
>> for making the changes. when did this change?
>
> It did not.
>
>>> Do you have this kind of hardware and are willing to accept ownership of
>>> this driver?
>>
>> no, I do not have the hardware, but if there are no bugs reported against
>> this driverit would seem that having a 'maintainer' who made absolutly no
>> changes to the driver (just allowing API changes by others to be
>> implemented) would be the same thing as having no maintainer, but in the
>> first case you are willing to have the driver in the kernel, in the other
>> you want to rip it out.
>>
>> it used to be (not that long ago) that when people said that the reason
>> they didn't push their driver upstream into the kernel because there
>> wasn't that much demand for it, the response was that we wanted drivers
>> for everything, no matter how small the user base. I remember seeing posts
>> from core developers saying that we had drivers for hardware where there
>> were only single digit quantities ever built.
>>
>> now it appears that you have to have 'enough' users (an amount undefined)
>
> That amount would be 1.  This driver does not have that, so it can be
> removed.

while I definantly agree that this driver is unlikly to have many users, 
unless it is known broken (which David Miller has stated that it is, but 
had not been mentioned previously in this thread), how can you know that 
the number of users has dropped below 1?

David Lang
