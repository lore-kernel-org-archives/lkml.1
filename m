Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbXIZOvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbXIZOvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbXIZOvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:51:13 -0400
Received: from h90-m1.hosting90.cz ([81.0.225.70]:46068 "EHLO
	h90-m1.hosting90.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbXIZOvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:51:12 -0400
Message-ID: <46FA71E0.8080406@prepere.com>
Date: Wed, 26 Sep 2007 16:51:12 +0200
From: Miloslav Semler <majkls@prepere.com>
User-Agent: IceDove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Kyle Moffett <mrmacman_g4@mac.com>, David Newall <david@davidnewall.com>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com> <46FA341A.80706@davidnewall.com> <6BA6E9EE-B67B-4334-AC83-9B8E30527832@mac.com> <46FA5A85.20407@prepere.com> <20070926134223.GO8181@ftp.linux.org.uk>
In-Reply-To: <20070926134223.GO8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro napsal(a):
> On Wed, Sep 26, 2007 at 03:11:33PM +0200, Miloslav Semler wrote:
>   
>>> As for the nested-chroot() bit, the root user inside of a chroot is 
>>> always allowed to chroot().  This is necessary for test-suites for 
>>> various distro installers, chroot once to enter the installer playpen, 
>>> installer chroots again to configure the test-installed-system.  Once 
>>> you allow a second chroot, you're back at the "can't reliably and 
>>> efficiently track directory sub-tree members" problem.
>>>
>>> So if you think it can and should be fixed, then PROVIDE THE CODE.
>>>       
>> Miloslav Semler
>>     
>
> man openat
>
> This is really pointless, anyway - any code that expects chroot to be
> root-proof is terminally broken.
>   
So thanks for information. I did't know anything about *at functions. So 
it seems to be more complicated. But maybe it will be good write to 
manpage "other systems implement it by other way, so this feature is 
unportable".
