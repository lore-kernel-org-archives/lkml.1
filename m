Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbXGMLD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbXGMLD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbXGMLDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:03:52 -0400
Received: from smtp.cce.hp.com ([161.114.21.25]:45997 "EHLO
	ccerelrim04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbXGMLDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:03:51 -0400
X-Greylist: delayed 1349 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2007 07:03:51 EDT
From: "Paul Moore" <paul.moore@hp.com>
Subject: Re: [GIT] SELinux changes for 2.6.23 (updated)
Date: 13 Jul 2007 06:41:00 -0400
To: <jmorris@namei.org>
X-Mailer: ChatterEmail+ for Treo 6xx/700p (3.0.8)
Message-ID: <3267153665.17485311@mail.hp.com>
Cc: <michal.k.k.piotrowski@gmail.com>, <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <sds@tycho.nsa.gov>
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.7.13.32233
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: James Morris <jmorris@namei.org>
Date: Thursday, Jul 12, 2007 10:50 pm
Subject: Re: [GIT] SELinux changes for 2.6.23 (updated)
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,	linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,	Paul Moore <paul.moore@hp.com>

On Fri, 13 Jul 2007, Michal Piotrowski wrote:
>
>> 
> My system is too secure, I can not login :)
>
>Do you have CONFIG_NETLABEL=y ?
>
>If so, please try disabling it.

Disabling NetLabel should solve the problem.  The recommended solution to this problem, as discussed on the SELinux list and mentioned in the patch description, is to upgrade your SELinux policy to the latest Reference Policy sources.  For those with custom SELinux policy, the patch description explains the changes to the SELinux policy required. 

If needed I can post more instructions later, let me know, but right now I'm tapping this out on my phone while at the airport.

. paul moore
. linux security @ hp


