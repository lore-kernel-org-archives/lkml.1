Return-Path: <linux-kernel-owner+w=401wt.eu-S1032457AbXEHWAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032457AbXEHWAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032450AbXEHWAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:00:49 -0400
Received: from gw.goop.org ([64.81.55.164]:34530 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032431AbXEHWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:00:48 -0400
Message-ID: <4640F30C.7080901@goop.org>
Date: Tue, 08 May 2007 15:00:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Howells <dhowells@redhat.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>
Subject: Re: [patch 3/4] split usermodehelper setup from execution
References: <20070508205129.064843364@goop.org>	<20070508205517.256147592@goop.org> <20070508150156.402980c6.randy.dunlap@oracle.com>
In-Reply-To: <20070508150156.402980c6.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 08 May 2007 13:51:32 -0700 Jeremy Fitzhardinge wrote:
>
>   
>> --- a/kernel/kmod.c
>> +++ b/kernel/kmod.c
>> @@ -253,11 +262,94 @@ static void __call_usermodehelper(struct
>>  }
>>  
>>  /**
>> - * call_usermodehelper_keys - start a usermode application
>> - * @path: pathname for the application
>> - * @argv: null-terminated argument list
>> - * @envp: null-terminated environment list
>> - * @session_keyring: session keyring for process (NULL for an empty keyring)
>> + * call_usermodehelper_setup - prepare to call a usermode helper
>> + * @path - path to usermode executable
>> + * @argv - arg vector for process
>> + * @envp - environment for process
>>     
>
> s / - /: / above please.
>   

The power of cut'n'paste makes the errors consistent, at least...  Will
fix up.

    J
