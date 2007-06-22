Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXFVDpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXFVDpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 23:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbXFVDpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 23:45:46 -0400
Received: from exchange.columbia.tresys.com ([216.250.243.126]:7475 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750815AbXFVDpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 23:45:45 -0400
Message-ID: <467B45E0.3040207@manicmethod.com>
Date: Thu, 21 Jun 2007 23:45:36 -0400
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: david@lang.hm
CC: Lars Marowsky-Bree <lmb@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070621211743.GN20105@marowsky-bree.de> <467B14D9.8050000@manicmethod.com> <Pine.LNX.4.64.0706211722440.31603@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706211722440.31603@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2007 03:45:43.0847 (UTC) FILETIME=[CF800B70:01C7B47F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Thu, 21 Jun 2007, Joshua Brindle wrote:
>
>> Lars Marowsky-Bree wrote:
>>>  On 2007-06-21T16:59:54, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>>  <snip>
>>>
>>>
>>> >  Um, no.  It might not be able to directly open files via that 
>>> path, but
>>> >  showing that it can never read or write your mail is a rather 
>>> different
>>> >  matter.
>>> >
>>>  Yes. Your use case is different than mine.
>>>
>>
>> So.. your use case is what? If an AA user asked you to protect his 
>> mail from his browser I'm sure you'd truthfully answer "no, we can't 
>> do that but we can protect the path to your mail from your browser".. 
>> I think not. One need only look at the wonderful marketing literature 
>> for AA to see what you are telling people it can do, and your above 
>> statement isn't consistent with that, sorry.
>
> remember, the policies define a white-list
>

Except for unconfined processes.

> so if a hacker wants to have mozilla access the mail files he needs to 
> get some other process on the sysstem to create a link or move a file 
> to a path that mozilla does have access to. until that is done there 
> is no way for mozilla to access the mail through the filesystem.
>
> other programs could be run that would give mozilla access to the mail 
> contents, but it would be through some other path that the policy 
> permitted mozilla accessing in the first place.
>
Or through IPC or the network, that is the point, filesystem only 
coverage doesn't cut it; there is no way to say the browser can't access 
the users mail in AA, and there never will be.

