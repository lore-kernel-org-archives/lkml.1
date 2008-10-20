Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYJTVi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYJTVi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbYJTViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:38:05 -0400
Received: from xenotime.net ([66.160.160.81]:55312 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755883AbYJTViE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:38:04 -0400
Message-ID: <48FCFA30.9000707@xenotime.net>
Date: Mon, 20 Oct 2008 14:37:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH] Document kernel taint flags properly
References: <20081017225515.GA14133@kroah.com> <cfd18e0f0810180151v232f623pdbf0f12cad6532d6@mail.gmail.com> <20081020204318.GB21131@kroah.com>
In-Reply-To: <20081020204318.GB21131@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Oct 18, 2008 at 03:51:11AM -0500, Michael Kerrisk wrote:
>   
>> Greg,
>>
>> Small corrections below.
>>
>> On Fri, Oct 17, 2008 at 5:55 PM, Greg KH <greg@kroah.com> wrote:
>>     
>>> From: Greg Kroah-Hartman <gregkh@suse.de>
>>>
>>> This fills in the documentation for all of the current kernel taint
>>> flags, and fixes the number for TAINT_CRAP, which was incorrectly
>>> described.
>>>
>>> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
>>> Cc: Randy Dunlap <rdunlap@xenotime.net>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>>
>>> ---
>>>  Documentation/sysctl/kernel.txt |   24 +++++++++++++++++-------
>>>  1 file changed, 17 insertions(+), 7 deletions(-)
>>>
>>> --- a/Documentation/sysctl/kernel.txt
>>> +++ b/Documentation/sysctl/kernel.txt
>>> @@ -363,11 +363,21 @@ tainted:
>>>  Non-zero if the kernel has been tainted.  Numeric values, which
>>>  can be ORed together:
>>>
>>> -  1 - A module with a non-GPL license has been loaded, this
>>> -      includes modules with no license.
>>> -      Set by modutils >= 2.4.9 and module-init-tools.
>>> -  2 - A module was force loaded by insmod -f.
>>> -      Set by modutils >= 2.4.9 and module-init-tools.
>>> -  4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
>>> - 64 - A module from drivers/staging was loaded.
>>> +   1 - A module with a non-GPL license has been loaded, this
>>> +       includes modules with no license.
>>> +       Set by modutils >= 2.4.9 and module-init-tools.
>>> +   2 - A module was force loaded by insmod -f.
>>> +       Set by modutils >= 2.4.9 and module-init-tools.
>>> +   4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
>>> +   8 - A module was forcefully unloaded from the system by rmmod -f.
>>>       
>> s/forcefully/forcibly/
>>
>>     
>>> +  16 - A hardware machine check error occured on the system.
>>>       
>> occurred
>>     
>
> Thanks, I've updated this in my version.
>
> Randy, I can send this through my tree, is that ok?  Or do you want it
> to go through yours?
>   
You please go ahead with it.

Thanks,
~Randy

