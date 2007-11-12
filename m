Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbXKLX6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbXKLX6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbXKLX6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:58:25 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:56573 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752494AbXKLX6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:58:24 -0500
Message-ID: <4738E8A2.1060004@crispincowan.com>
Date: Mon, 12 Nov 2007 15:58:26 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: david@lang.hm, "Dr. David Alan Gilbert" <linux@treblig.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
References: <473380AD.5070801@crispincowan.com>	<20071110220455.GB24195@gallifrey>	<47362C7C.2050202@crispincowan.com>	<20071110222414.GC24195@gallifrey>	<47363381.4030103@crispincowan.com>	<20071110232545.GD24195@gallifrey>	<Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm> <20071110235609.00958d87@the-village.bc.nu>
In-Reply-To: <20071110235609.00958d87@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> but how can the system know if the directory the user wants to add is 
>> reasonable or not? what if the user says they want to store their 
>> documents in /etc?
>>     
> A more clear example is wanting to wrap a specific tool with temporary
> rules. Those rules would depend on the exact file being edited at this
> moment - something root cannot know in advance
> (although with apparmor I guess mv $my_file apparmour_magic.name ; foo;
> mv it back might work 8))
>   
If you have unconfined root privilege on an AppArmor box, then setting
up a temporary profile is trivial. As Alan suggests, you could just have
a standard profile for /home/crispin/bin/foo and fun with mv would
switch programs in and out of it. Or for more control, just draft a new
policy and load it; it just takes a few seconds to cp the profile for
something else and edit it a bit, and then load it.

The big difference between the former and latter is that the former is
inflexible (it either works or it doesn't) and the latter requires
privilege.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

