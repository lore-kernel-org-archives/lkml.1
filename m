Return-Path: <linux-kernel-owner+w=401wt.eu-S1751802AbXKMIXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbXKMIXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 03:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXKMIXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 03:23:25 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:33322 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750909AbXKMIXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 03:23:24 -0500
Message-ID: <47395F00.6080507@crispincowan.com>
Date: Tue, 13 Nov 2007 00:23:28 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: rmeijer@xs4all.nl, apparmor-dev@forge.novell.com
CC: Crispin Cowan <crispin@crispincowan.com>,
       LSM ML <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Apparmor-dev] Re: AppArmor Security Goal
References: <10657.80.126.27.205.1194933072.squirrel@webmail.xs4all.nl>
In-Reply-To: <10657.80.126.27.205.1194933072.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sent with proper addressing ...

Rob Meijer wrote:
>> The
>> system is "defended" in that the worst the attacker can do to corrupt
>> the system is limited to the transitive closure of what the confined
>> processes are allowed to access.
>>     
> The damage the atacker can do would be defined by the authority not the
> permissions the process has.
>   
As far as I can tall, the transitive closure of permissions is precisely
authority.

>>     * AppArmor confines processes if they are children of a confined
>>       process, or if the name of the exec'd child matches the name of an
>>       AppArmor profile.
>>     
> What is left unspecified here is 'how' a child 'with its own profile' is
> confined here. Are it is confined to just its own profile, it may that
> the "complicit process" communication may need to be wider specified to
> include this.
>   
It is deliberately unspecified in this document, because it is a matter
of policy. And this item that you've excerpted is just one of a list of
specific disclaimers that were put here in response to criticisms and
misunderstandings of AppArmor in the past.

Remember, the purpose of *this* document is to define the security goals
that AppArmor has to live up to. It is fine to use it as a jumping off
point for design ideas that some system might employ some day, or even
proposed enhancements to AppArmor itself, but don't over-burden the
"security goal" document, it needs to be short & comprehensible.

>>     * A confined process can operate on a file descriptor passed to it
>>       by an unconfined process, even if it manipulates a file not in the
>>       confined process's profile. To block this attack, confine the
>>       process that passed the file descriptor.
>>     
> This should not count as an 'attack' given that the unconfined process
> would either be trusted, or be mallicious and fall inside the "influence"
> of the confined process anyway.
>   
It counts as a surprising result, and so is specifically disclaimed. I
can tell it is surprising, because it surprised Andi Kleen :)

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work
