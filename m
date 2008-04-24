Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbYDXAWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbYDXAWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYDXAWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:22:32 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:21062 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753298AbYDXAWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V5LBcQxNyjA5E3r6dcag5+K2Hm1LcelKekQewzK52MBE8ZtdO9vdfyWjpBxGgNVG2EU5pZgC0ZxjkVjDCvdB/GgsQF0czUlpz/Gl+t7wnPEg9od41pMZJOoBx6kruCDQMFOwfC7R4IUDETw/DZ08vS9Y3w2MRkkc3hann7A6Bz4=
Message-ID: <9a8748490804231722o66ccb740q94b50c9ca7ba23ab@mail.gmail.com>
Date: Thu, 24 Apr 2008 02:22:30 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Kevin Winchester" <kjwinchester@gmail.com>
Subject: Re: [PATCH] Let SYSVIPC default to 'y'
Cc: linux-kernel@vger.kernel.org,
       "Krishna Balasubramanian" <balasub@cis.ohio-state.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <480FCDA6.6000509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0804240057240.2438@dragon.funnycrock.com>
	 <480FCDA6.6000509@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/2008, Kevin Winchester <kjwinchester@gmail.com> wrote:
> Jesper Juhl wrote:
>
> > SYSVIPC is a pretty crucial feature that I doubt very much if anyone
> except embedded people should even consider disabling - it simply breaks too
> much software for a Linux box to really be useful without it, for most
> purposes.
> > For that reason I find it quite odd that the feature defaults to 'No'
> currently.  I really cannot see any reason why we wouldn't want this to
> default to 'Yes', so this patch changes the default by adding 'default y' to
> Kconfig.
> >
<...snip...>
>
>  I am running up-to-date Kubuntu Hardy Heron, but...
>
>  kevin@alekhine:~/linux/linux-2.6$ grep SYSVIPC .config
>  # CONFIG_SYSVIPC is not set
>
>  What software that would be in a standard install would be broken?  I don't
> seem to notice anything...
>
>  Not that I mind the default being changed - I just wonder if things on my
> box are broken and I just don't know it.
>

Well,
  DOSEmu doesn't work without it.
  SysOrb (http://www.sysorb.com/) doesn't work without it AFAIK.
  IIRC, X had trouble in the past without it.
  Anything that uses SysV shared memory, SysV message passing
(msgget(), msgsnd() etc..),
  SysV semaphores (semget() etc), will have trouble.
  In general, System V IPC is just used by many different programs...
Perhaps not any you run,
  but it is pretty widely used.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
