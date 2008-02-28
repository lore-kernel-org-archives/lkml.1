Return-Path: <linux-kernel-owner+w=401wt.eu-S1764539AbYB1VIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764539AbYB1VIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760393AbYB1VIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:08:10 -0500
Received: from mail.tmr.com ([64.65.253.246]:52614 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761852AbYB1VII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:08:08 -0500
Message-ID: <47C72365.4060506@tmr.com>
Date: Thu, 28 Feb 2008 16:11:01 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: James Morris <jmorris@namei.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, eparis@parisplace.org,
       casey@schaufler-ca.com
Subject: Re: SMACK or SELinux, but not both
References: <20080226090953.GA7469@localhost.sw.ru>	 <Xine.LNX.4.64.0802262020001.527@us.intercode.com.au> <1204029576.2804.260.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1204029576.2804.260.camel@moss-spartans.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley wrote:
> On Tue, 2008-02-26 at 20:28 +1100, James Morris wrote:
>> On Tue, 26 Feb 2008, Alexey Dobriyan wrote:
>>
>>> If SELinux is registered before SMACK, SMACK panics after
>>> register_security() call.
>>>
>>> If SMACK is registered before SELinux, SELinux panics after
>>> register_security() call.
>>>
>>> Consequently allmodconfig kernel doesn't boot. It would be nice if
>>> some Kconfig magic to exclude each other will be in place.
>> People want to be able to select the security model at boot time, so the 
>> option to build both LSMs is required.
>>
>> You can stop SELinux from attempting to register as an LSM via selinux=0, 
>> which should allow you to boot with just Smack enabled.
> 
> Ideally, one could just boot with security=<module> to select the
> desired primary security module.  security=smack, security=selinux, or
> security=capability.
> 
> Having to specify selinux=0 smack=0 foo=0 just to get bar wouldn't be
> pretty.  Not that anyone would want to do that, of course...
> 
And doesn't scale well as we add more security models. Oh, that will 
never happen, right? I still like "security="

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
