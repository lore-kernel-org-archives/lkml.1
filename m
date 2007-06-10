Return-Path: <linux-kernel-owner+w=401wt.eu-S1763078AbXFJUwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078AbXFJUwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbXFJUvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:51:53 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51621 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbXFJUvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:51:52 -0400
Message-ID: <466C6451.6030907@novell.com>
Date: Sun, 10 Jun 2007 13:51:29 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: david@lang.hm, Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <700465.32295.qm@web36612.mail.mud.yahoo.com>
In-Reply-To: <700465.32295.qm@web36612.mail.mud.yahoo.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> --- david@lang.hm wrote:
>   
>>> Yes, and in the process, AA stores compiled regular expressions in
>>> kernel. Ouch. I'll take "each file it's own label" over _that_ any time.
>>>       
>> and if each file has it's own label you are going to need regex or similar 
>> to deal with them as well.
>>     
> Now that you're going to have to explain. Nothing like that 
> on any of the MLS systems I'm familiar with, and I think that
> I know just about all of them.
>   
I suspect that David meant that if you were using "unique label per
file" as an implementation technique to implement AA on top of SELinux,
that you would then need a regexp to discern labels.

It's hard to recall with all the noise, but at this point in the thread
the discussion is about the best way to implement AA. Some have alleged
that AA layered on top of SELinux is the best way. I think that is
clearly wrong; AA layered on top of SELinux is possible, but would
require a bunch of enhancements to SELinux first, and the result would
be more complex than the proposed AA patch and have weaker functionality
and performance.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
	AppArmor Chat: irc.oftc.net/#apparmor

