Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbXJ3GOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbXJ3GOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 02:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbXJ3GOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 02:14:03 -0400
Received: from fep02.mfe.bur.connect.com.au ([203.63.86.22]:53786 "EHLO
	fep02.mfe.bur.connect.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbXJ3GOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 02:14:00 -0400
Message-ID: <4726D9D9.2000909@ii.net>
Date: Tue, 30 Oct 2007 15:14:33 +0800
From: Cliffe <cliffe@ii.net>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Defense in depth: LSM *modules*, not a static interface
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>	 <4726377A.4080807@crispincowan.com> <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
In-Reply-To: <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Defense in depth has long been recognised as an important secure design 
principle. Security is best achieved using a layered approach.

On a single system it makes sense to have a layered approach such as:

Standard DAC (where users are in control of permissions)
Some form of user-based non-DAC (where admins can specify what users can 
specifically do) such as SELinux or SMACK
System-wide firewall (netfilter)
Some form of sandboxes/namespace isolation (chroot, jails...)
General application confinement such as DTE (SELinux), or Capability 
lists (AppArmor, systrace ...)
Application network confinement - firewall to confine individual apps 
(maybe included in the above)
IDS or IPS
Malware scanner
Posix Capabilities
Pax/RaceGuard
...[insert innovation here]...

And while I acknowledge that many of these layers are currently buried 
within the kernel (netfilter...) they are security layers which in many 
cases would probably make sense as stackable security modules.

Making the interface static forces mammoth solutions which then must 
attempt to solve all of the above in one ls*m*. What happened to 
dividing tasks into easy to manage chunks?

Regards,

Z. Cliffe Schreuders
BSc Comp Sci (Hons) & Int Comp
PhD Candidate, Casual Tutor
School of IT
Murdoch University

