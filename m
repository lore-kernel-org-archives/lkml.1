Return-Path: <linux-kernel-owner+w=401wt.eu-S1764739AbXLTWtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764739AbXLTWtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764005AbXLTWsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:48:51 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15489 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763448AbXLTWsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:48:50 -0500
Message-ID: <476AF124.6090404@oracle.com>
Date: Thu, 20 Dec 2007 14:48:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
References: <20071220003031.GA15129@kroah.com> <20071219223206.ada18362.randy.dunlap@oracle.com> <20071220212700.GB5808@kroah.com> <20071220140659.71f6cce6.randy.dunlap@oracle.com> <20071220221252.GA16431@kroah.com> <20071220142952.ff562b22.randy.dunlap@oracle.com> <20071220224258.GA16932@kroah.com>
In-Reply-To: <20071220224258.GA16932@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Dec 20, 2007 at 02:29:52PM -0800, Randy Dunlap wrote:
>> On Thu, 20 Dec 2007 14:12:52 -0800 Greg KH wrote:
>>
>>> On Thu, Dec 20, 2007 at 02:06:59PM -0800, Randy Dunlap wrote:
>>>> On Thu, 20 Dec 2007 13:27:00 -0800 Greg KH wrote:
>>>>> On Wed, Dec 19, 2007 at 10:32:06PM -0800, Randy Dunlap wrote:
>>>>>> On Wed, 19 Dec 2007 16:30:31 -0800 Greg KH wrote:
>>>>>>>     int kobject_uevent(struct kobject *kobj, enum kobject_action action);
>>>>>>>
>>>>>>> Use the KOBJ_ADD action for when the kobject is first added to the kernel.
>>>>>>> This should be done only after any attributes or children of the kobject
>>>>>>> have been initialized properly, as userspace will instantly start to look
>>>>>> 		s/will/may/
>>>>> No, it's usually a "will", as udev is damm fast these days :)
>>>> But that's the point.  It assumes that udev is being used.  :(
>>> Yes, kernel developers need to be aware that udev _will_ be used, you
>>> can not do things that will assume it is not running.
>> so are you saying that udev is required now?
>> I missed that information somehow/somewhere.
> 
> No, not at all, it's not required.
> 
> Just that if you are creating kobjects, you need to be aware that there
> are programs out there, like udev[1], that expect once the kobject is
> announced, to have all of the attributes present at the same time.
> 
> Does that explain it better?

Yes.  Thanks.

> thanks,
> 
> greg k-h
> 
> [1] There are at least 2 other programs like udev used by distros these
> days, udev is not the only player in this area anymore.


-- 
~Randy
