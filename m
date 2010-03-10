Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0CJK0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:26:04 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21906 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab0CJK0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:26:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=g8+0/jBpm9uLv12ab3TZBohxMnPE/R/kqM//Ygxaf0PlcDSCrXJa10nt+2WrmoxaR
	4Gi2g0aGJ88T8XP4QjTnA==
Date: Wed, 10 Mar 2010 02:25:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Jakub Narebski <jnareb@gmail.com>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       git@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Sixt <j.sixt@viscovery.net>
Subject: Re: [PATCH 1/1] gitignore: do not ignore include/linux/
In-Reply-To: <2375c9f91003100211vbe66a49g1bec37b2dcf609c2@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1003100223090.30021@chino.kir.corp.google.com>
References: <4B90CBE5.9090102@viscovery.net> <1267780845-10547-1-git-send-email-jslaby@suse.cz> <m3pr3jkq26.fsf@localhost.localdomain> <4B9120F2.2020000@gmail.com> <alpine.DEB.2.00.1003100205170.17698@chino.kir.corp.google.com>
 <2375c9f91003100211vbe66a49g1bec37b2dcf609c2@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531400454-795328965-1268216754=:30021"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531400454-795328965-1268216754=:30021
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 10 Mar 2010, Américo Wang wrote:

> >> >> +!/.gitignore
> >> >> +!/.mailmap
> >> >
> >> > Actually you want to *not ignore* .gitignore and .mailmap (and
> >> > .gitattributes which is missing here) anywhere, not only as top-level
> >> > file.  So .gitignore and .mailmap should not be prepended with slash.
> >>
> >> <and moved out of the 'Top-level generic files' section then>
> >>
> >
> > Please either revert 3b2a8c8f3c65 or merge the fixed up patch for
> > 2.6.34-rc2, otherwise include/linux will continue to be ignored by git
> > just like it is for 2.6.34-rc1.
> 
> Why not apply the patch from Jiri? Since this problem is introduced
> by new version of git, not that commit.
> 

Like I said, please either revert the commit that added "linux" to 
.gitignore or merge Jiri's patch.  I'm not interested in engaging in a 
discussion about what can or cannot be merged during rc cycles, I just 
hope this is resolved for rc2.
--531400454-795328965-1268216754=:30021--
