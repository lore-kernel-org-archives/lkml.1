Return-Path: <linux-kernel-owner+w=401wt.eu-S1764378AbYDOOaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764378AbYDOOaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbYDOOaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:30:21 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56779 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYDOOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:30:20 -0400
Message-ID: <4804BBE6.1080202@panasas.com>
Date: Tue, 15 Apr 2008 17:29:58 +0300
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Martin Knoblauch <spamtrap@knobisoft.de>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org,
       am-utils <am-utils@am-utils.org>
Subject: Re: User space automounter problems after upgrade to 2.6.25-rc9
References: <914095.44950.qm@web32604.mail.mud.yahoo.com>
In-Reply-To: <914095.44950.qm@web32604.mail.mud.yahoo.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 15, 2008, 16:58 +0300, Martin Knoblauch <spamtrap@knobisoft.de> wrote:
> ----- Original Message ----
>> From: Trond Myklebust <trond.myklebust@fys.uio.no>
>> To: Martin Knoblauch <spamtrap@knobisoft.de>
>> Cc: linux-kernel@vger.kernel.org; am-utils <am-utils@am-utils.org>
>> Sent: Tuesday, April 15, 2008 2:57:26 PM
>> Subject: Re: User space automounter problems after upgrade to 2.6.25-rc9
>>
>>
>> On Tue, 2008-04-15 at 04:28 -0700, Martin Knoblauch wrote:
>>> Hi,
>>>
>>>  after booting a newly built 2.6.25-rc9 kernel, I see the following messages 
>> and the user space automounter fails to work. Last good kernel for me is 2.6.24, 
>> as -rc9 is my first attempt at 2.6.25. Extremely sorry for being late to the 
>> game :-(
>>> [   13.776876] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
>>> [   11.996757] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
>>> [   14.504927] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
>>> [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
>>> [   14.504927] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
>>> [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
>>> [   14.505079] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
>>> [   11.996757] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
>>> [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
>>> [   12.688801] Invalid hostname "pid4302@lpsdm60:/soft" in NFS lock request
>>>
>>> am-utils version is 6.1.5, config is attached
>> Already reported in:
>>    http://bugzilla.kernel.org/show_bug.cgi?id=10349
>> and
>>    https://bugzilla.am-utils.org/show_bug.cgi?id=612
>>
>> The problem is due to known bugs in the am-utils mount code (no,
>> 'pid4302@lpsdm60:/soft' is not and has never been a valid server
>> hostname).
>>
> 
>  I always wondered, but never asked :-) Apparently the kernel did never care until recently.
> 
>> The workaround should be to turn off locking by adding the 'nolock'
>> mount flag.
>>
> 
>  Not sure what kind of side effects that will have. Probably better to stay at 2.6.24 and wait for a fix in am-utils.

FWIW, autofs works for me (Fedora 7, 2.6.25-rc*).

Benny

> 
> Cheers
> 
> Martin
> 

