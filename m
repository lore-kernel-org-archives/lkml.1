Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXEHWHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXEHWHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032463AbXEHWHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:07:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54594 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbXEHWHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:07:13 -0400
Date: Tue, 8 May 2007 15:10:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Howells <dhowells@redhat.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>
Subject: Re: [patch 3/4] split usermodehelper setup from execution
Message-Id: <20070508151050.f0c2c20f.randy.dunlap@oracle.com>
In-Reply-To: <4640F30C.7080901@goop.org>
References: <20070508205129.064843364@goop.org>
	<20070508205517.256147592@goop.org>
	<20070508150156.402980c6.randy.dunlap@oracle.com>
	<4640F30C.7080901@goop.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 15:00:44 -0700 Jeremy Fitzhardinge wrote:

> Randy Dunlap wrote:
> > On Tue, 08 May 2007 13:51:32 -0700 Jeremy Fitzhardinge wrote:
> >
> >   
> >> --- a/kernel/kmod.c
> >> +++ b/kernel/kmod.c
> >> @@ -253,11 +262,94 @@ static void __call_usermodehelper(struct
> >>  }
> >>  
> >>  /**
> >> - * call_usermodehelper_keys - start a usermode application
> >> - * @path: pathname for the application
> >> - * @argv: null-terminated argument list
> >> - * @envp: null-terminated environment list
> >> - * @session_keyring: session keyring for process (NULL for an empty keyring)
> >> + * call_usermodehelper_setup - prepare to call a usermode helper
> >> + * @path - path to usermode executable
> >> + * @argv - arg vector for process
> >> + * @envp - environment for process
> >>     
> >
> > s / - /: / above please.
> >   
> 
> The power of cut'n'paste makes the errors consistent, at least...  Will
> fix up.

Thanks.  If you point me to such foobars (in general), I'll fix them up.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
