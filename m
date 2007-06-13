Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbXFMW6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbXFMW6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXFMW61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:58:27 -0400
Received: from sokol.elan.net ([216.151.192.200]:45833 "EHLO sokol.elan.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbXFMW60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:58:26 -0400
X-Greylist: delayed 1461 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 18:58:25 EDT
Date: Wed, 13 Jun 2007 16:32:14 -0700 (PDT)
From: "william(at)elan.net" <william@elan.net>
To: Toshiharu Harada <haradats@gmail.com>
cc: Rik van Riel <riel@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Toshiharu Harada <haradats@nttdata.co.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC] TOMOYO Linux
In-Reply-To: <9d732d950706131525n667587e6t59e94c5cee951c6d@mail.gmail.com>
Message-ID: <Pine.LNX.4.62.0706131631280.1344@sokol.elan.net>
References: <466FA71C.1020309@nttdata.co.jp>  <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>
  <9d732d950706130722g12a22604p223381a8e281a4a1@mail.gmail.com> 
 <46704D49.8010308@redhat.com>  <9d732d950706131435s636b852di98026aed1d9a6ac6@mail.gmail.com>
  <467064B9.1080005@redhat.com> <9d732d950706131525n667587e6t59e94c5cee951c6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 14 Jun 2007, Toshiharu Harada wrote:

> 2007/6/14, Rik van Riel <riel@redhat.com>:
>> Toshiharu Harada wrote:
>> > 2007/6/14, Rik van Riel <riel@redhat.com>:
>> > SELinux has a well designed robust and flexible functions.
>> > So it should be used for everywhere.  I understand it.
>> > As you mentioned one can analyze the system (process)
>> > behaviors from AVC logs. But the maintenance cost is not trivial.
>> >
>> > If logging with process context is the only purpose,
>> > current TOMOYO Linux can do it with no hustle at all.
>> 
>> Yes, but so does standard SELinux.
>> 
>> You are making me curious: what does TOMOYO do that is
>> not done by regular SELinux?
>> 
>> Logging with process name, path name and contexts is
>> already done.  I must have missed some other TOMOYO
>> feature in your initial email...
>
> I see SELinux can log with process name, path name and
> contexts, but "contexts" must be defined beforehand.
> TOMOYO Linux kernel does that with pathname, so no
> label definitions needed.
> You can confirm the process (domain) transitions any time
> and access occurred are clarified per domain basis automatically.
> Security context in TOMOYO Linux is represented and stored
> as a call chain and very intuitive.
>
> TOMOYO Linux has a mode called "learning"
> in addition to "permissive" and "enforce". You can easily
> get the TOMOYO Linux policy with learning mode that
> SELinux does not have. In addition, access control mode of
> TOMOYO Linux can be managed for every difference domain.

This sounds a like like feature differences "compared" at:
  http://www.novell.com/linux/security/apparmor/selinux_comparison.html

-- 
William Leibzon
Elan Networks
william@elan.net
