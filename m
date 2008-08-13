Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYHMNwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYHMNwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYHMNwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:52:07 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:35944 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbYHMNwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:52:06 -0400
In-Reply-To: <20080813125638.GB6995@ucw.cz>
To: Pavel Machek <pavel@suse.cz>
Cc: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       davecb@sun.com, Greg KH <greg@kroah.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access
 scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 13 Aug 2008 14:52:01 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 13/08/2008 14:52:01,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 13/08/2008 14:52:01,
	Serialize complete at 13/08/2008 14:52:01,
	S/MIME Sign failed at 13/08/2008 14:52:01: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 13/08/2008 14:52:03,
	Serialize complete at 13/08/2008 14:52:03
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080813135207.CC08C3765BC@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote on 13/08/2008 13:56:38:

Big snip since I am really only curious about libmalware.so.

> Plus, proposed solution already has three unacceptable holes:
> 
> 1) it only catches known signatures
> 2) write vs. read race mentioned above

Discussions about perfect, better or no security are in danger of becoming 
boring.

> 3) mmap problem
> 
> . Making sure all apps use libmalware.so is trivial compared to
> solving 3).

You haven't answered what exactly is this libmalware.so, since you are the 
only one mentioning it? It would be interesting to learn how it solves the 
mmap problem, provides perfect security so it is acceptable, handles the 
kernel NFS server serving malicious files, caters for applications which 
do not use it, is better (more secure) than the kernel solution, provides 
reasonalbe performance and is easier to maintain for the community? To 
list only some of the requirements which have been mentioned so far.

--
Tvrtko A. Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

