Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbXFMVme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbXFMVme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbXFMVm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:42:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbXFMVm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:42:26 -0400
Message-ID: <467064B9.1080005@redhat.com>
Date: Wed, 13 Jun 2007 17:42:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061004)
MIME-Version: 1.0
To: Toshiharu Harada <haradats@gmail.com>
CC: Stephen Smalley <sds@tycho.nsa.gov>,
       Toshiharu Harada <haradats@nttdata.co.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC] TOMOYO Linux
References: <466FA71C.1020309@nttdata.co.jp>	 <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>	 <9d732d950706130722g12a22604p223381a8e281a4a1@mail.gmail.com>	 <46704D49.8010308@redhat.com> <9d732d950706131435s636b852di98026aed1d9a6ac6@mail.gmail.com>
In-Reply-To: <9d732d950706131435s636b852di98026aed1d9a6ac6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiharu Harada wrote:
> 2007/6/14, Rik van Riel <riel@redhat.com>:
>> > So I think pathname based call chains are advantages for
>> > at least auditing and profiling.
>>
>> SELinux audit logs (well, whatever is in /var/log/audit on
>> my system) does show the path names of objects that fail to
>> be accessed as well as the name and context of the processes
>> trying to access them.
>>
>> This is with standard Fedora and RHEL installations.
> 
> Thank you for your comment.
> 
> SELinux has a well designed robust and flexible functions.
> So it should be used for everywhere.  I understand it.
> As you mentioned one can analyze the system (process)
> behaviors from AVC logs. But the maintenance cost is not trivial.
> 
> If logging with process context is the only purpose,
> current TOMOYO Linux can do it with no hustle at all.

Yes, but so does standard SELinux.

You are making me curious: what does TOMOYO do that is
not done by regular SELinux?

Logging with process name, path name and contexts is
already done.  I must have missed some other TOMOYO
feature in your initial email...

-- 
All Rights Reversed
