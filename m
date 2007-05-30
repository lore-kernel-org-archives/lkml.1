Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXE3FxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXE3FxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 01:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXE3Fww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 01:52:52 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45397 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbXE3Fwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 01:52:51 -0400
Message-ID: <465D111C.6060500@novell.com>
Date: Wed, 30 May 2007 01:52:28 -0400
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Kyle Moffett <mrmacman_g4@mac.com>, Toshiharu Harada <haradats@gmail.com>,
       James Morris <jmorris@namei.org>, casey@schaufler-ca.com,
       Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <Line.LNX.4.64.0705261442000.23020@d.namei> <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com> <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com> <9d732d950705270025p1bedae23ne137f024eb78886f@mail.gmail.com> <4F828E03-DA6B-484E-A8F2-885D1BC6F23E@mac.com> <9d732d950705280341x78575d85kaf95b0e2884723f3@mail.gmail.com>            <69A10107-78FE-4F11-AF52-9B8F648AFC0A@mac.com> <8219.1180473430@turing-police.cc.vt.edu>
In-Reply-To: <8219.1180473430@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 28 May 2007 21:54:46 EDT, Kyle Moffett said:
>   
>> Average users are not supposed to be writing security policy.  To be  
>> honest, even average-level system administrators should not be  
>> writing security policy.
That explains so much! "SELinux: you're too dumb to use it, so just keep
your hands in your pockets." :-)

AppArmor was designed to allow your average sys admin to write a
security policy. It makes different design choices than SELinux to
achieve that goal. As a result, AppArmor is an utter failure when
compared to SELinux's goals, and SELinux in turn is an utter failure
when compared to AppArmor's goals.

Which is why we have LSM: so we don't have to have this argument here,
again.

>>   It's OK for such sysadmins to tweak  
>> existing policy to give access to additional web-docs or such, but  
>> only expert sysadmin/developers or security professionals should be  
>> writing security policy.  It's just too damn easy to get completely  
>> wrong.
>>     
> The single biggest challenge in computer security at the present time is how to
> build *and deploy* servers that stay reasonably secure even when run by the
> average wave-a-dead-chicken sysadmin, and desktop-class boxes that can survive
> the best attempts of Joe Sixpack's "Ooh shiny" reflex, and Joe's kid's attempts
> to evade the nannyware that Joe had somebody install.
>   
That is a tall order. You can mostly achieve it by not giving the user
the root password, but I'm not sure you would like the result :-)

Both SELinux and AppArmor can be configured so tightly that you are not
going to get to install malware, by preventing the user from installing
software. This isn't what users want, so they invariably bypass security
and install shiny things if they own the box. SELinux and AppArmor can't
help but fail if you put them in that kind of harm's way.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
		   Security: It's not linear

