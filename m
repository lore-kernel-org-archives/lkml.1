Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYHMOQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYHMOQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYHMOQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:16:19 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:38847 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbYHMOQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:16:17 -0400
In-Reply-To: <20080813065401.1bbdcb07@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Adrian Bunk" <bunk@kernel.org>, davecb@sun.com,
       "Greg KH" <greg@kroah.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net, "Mihai Don??u" <mdontu@bitdefender.com>,
       "Pavel Machek" <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access
 scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 13 Aug 2008 15:16:12 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 13/08/2008 15:16:12,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 13/08/2008 15:16:12,
	Serialize complete at 13/08/2008 15:16:12,
	S/MIME Sign failed at 13/08/2008 15:16:12: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 13/08/2008 15:16:13,
	Serialize complete at 13/08/2008 15:16:13
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080813141618.696833764EA@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> wrote on 13/08/2008 14:54:01:

> > I am not sure what you are suggesting, and I may have missed the
> > libmalware proposal (I don't see any mention of that specific idea in
> > any other message).  However, just to be clear...  At no point did we
> > suggest that the kernel would do any scanning.  What we have been
> > interested in is a mechanism that can allow a scanning application to
> > be notified by the kernel of specific i/o events, for those events to
> > be blocked by the kernel until a user-space scan is done, and then the
> > user-space scan sends back allow or deny, at which point the i/o event
> > returns to the caller -- either success or error.  This is the only
> > way that malware can be guaranteed of being detected when it is used
> > (for local application purposes or for transmission to another
> > platform) or created. 
> 
> this is a very broad statement that ignores the LD_PRELOAD approach,
> and thus not true.

LD_PRELOAD does not solve at least knfsd and suid binaries. But we are 
going in circles. :)
 
> > Also, a solution that requires applications to be modified will not
> > work, because there is no way that we would be able to get ALL
> > applications on the machines to be modified in the required ways.  If
> > ANY applications are not so modified, then you have an unacceptable
> 
> you don't need to modify applications to make them use a library...

Same is true for a kernel solution. Plus, it also works for those who make 
system calls directly, knfsd and suid binaries, and we can have cheap and 
ultra-efficient caching. Not much kernel code, even less complex kernel 
code and unmeasurable impact when not used and compiled in. What are the 
big technical objections to that?

--
Tvrtko A. Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."
 

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

