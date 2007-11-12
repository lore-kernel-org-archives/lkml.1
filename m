Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbXKLXvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbXKLXvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbXKLXu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:50:58 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:53982 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750938AbXKLXu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:50:57 -0500
Message-ID: <4738E6E3.5090404@crispincowan.com>
Date: Mon, 12 Nov 2007 15:50:59 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey> <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey> <47363381.4030103@crispincowan.com> <20071110232545.GD24195@gallifrey>
In-Reply-To: <20071110232545.GD24195@gallifrey>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dr. David Alan Gilbert wrote:
> * Crispin Cowan (crispin@crispincowan.com) wrote:
>   
>> I mostly don't see this as a serious limitation, because almost everyone
>> has their own workstation, and thus has root on that workstation. There
>> are 2 major exceptions:
>>
>>     * Schools, where the "workstations" are thin client X terminals and
>>       everyone is logged into a giant shared machine. Sorry, AppArmor is
>>       not a good choice for that environment, but it is a pretty scarce
>>       environment.
>>     * Enterprises, where workers get their own workstation, but they
>>       don't get root. Well, the reason the worker doesn't get root is
>>       the enterprise doesn't trust them with it, and so not letting them
>>       edit security policy is probably a good idea.
>>     
> I don't actually see your distinction here between those two environments;
> why does it matter if there is one non-priveliged user or many?
>   
Because it is easier to solve if there is only one non-privileged user:
you just give them privilege (fun with chmod and sudo) to edit the
system policies, and you're done (assuming you are happy allowing the
non-privileged user to edit policy at all).

If there are lots of non-privileged users sharing a computer, then I
submit that solutions are either insecure, intractable, or purely
restrictive.

>> Can you explain why you want a non-privileged user to be able to edit
>> policy? I would like to better understand the problem here.
>>     
> I think it might depend on how strict the users starting point is;
> you could say:
>    1 This document editor can read and write any part of the users home
>      directory other than the . files.
>
> or you could say:
>    2 This document editor can read any files but only write to the
>      'Documents directory'.
>
> If the adminisrator set something up with (2) as the starting point it
> would seem reasonable for the user to be able to add the ability to edit
> documents in extra directories for their style of organising documents
> they work on; but they would be restricted in what they could add
> so that they couldn't add the ability to write to their settings
> files.
>   
Ok, I can see where that would be useful in theory. But solving it is
VERY hard in practice, and AppArmor is not attempting to address this
problem of user extensibility of mandatory access controls.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

