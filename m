Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbXFJUzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbXFJUzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbXFJUzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:55:10 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51710 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbXFJUzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:55:08 -0400
Message-ID: <466C6518.9070501@novell.com>
Date: Sun, 10 Jun 2007 13:54:48 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: david@lang.hm
CC: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de> <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Fri, 8 Jun 2007, Greg KH wrote:
>> I still want to see a definition of the AA "model" that we can then use
>> to try to implement using whatever solution works best.  As that seems
>> to be missing the current argument of if AA can or can not be
>> implemented using SELinux or something totally different should be
>> stopped.
> the way I would describe the difference betwen AA and SELinux is:
>
> SELinux is like a default allow IPS system, you have to describe
> EVERYTHING to the system so that it knows what to allow and what to stop.
>
> AA is like a default deny firewall, you describe what you want to
> happen, and it blocks everything else without you even having to
> realize that it's there.
That's not quite right:

    * SELinux Strict Policy is a default-deny system: it specifies
      everything that is permitted system wide, and all else is denied.
    * AA and the SELinux Targeted Policy are hybrid systems:
          o default-deny within a policy or profile: confined processes
            are only permitted to do what the policy says, and all else
            is denied.
          o default-allow system wide: unconfined processes are allowed
            to do anything that classic DAC permissions allow.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
	AppArmor Chat: irc.oftc.net/#apparmor

