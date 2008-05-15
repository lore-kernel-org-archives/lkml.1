Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYEOCoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYEOCoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYEOCnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:43:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:16143 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYEOCnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZV7IgRRP6cYfvlXKbeiAFDTKOHoqf3Xtr1jYyqRqJoPeLcHMtB31t3XrFU5FSY4EogMnHrUI/vt+2EKLI3yusG9LqXYdDDECf86/Xu1WmMb1KDcQQmDq8gIcpD5ecB1KTccKcJm1eHB1cBKVUP54TF/ZWqOO9MYkQeIcjQpePj0=
Message-ID: <a4e6962a0805141943va8a9043k9ca3ff023bc6aa5@mail.gmail.com>
Date: Wed, 14 May 2008 21:43:50 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PULL] v9fs bug fixes and documentation updates for 2.6.26
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
In-Reply-To: <alpine.LFD.1.10.0805141930530.3019@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4e6962a0805141920x7d96df33gb9c22a5777b1732c@mail.gmail.com>
	 <alpine.LFD.1.10.0805141930530.3019@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 9:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 14 May 2008, Eric Van Hensbergen wrote:
>>
>> Jim Meyering (1):
>>       fs/9p/v9fs.c (v9fs_parse_options): Handle kstrdup and
>> match_strdup failure. Now that this function can fail, return an int,
>> diagnose other option-parsing failures, and adjust the sole caller:
>> (v9fs_session_init): Handle kstrdup failure. Propagate any new
>> v9fs_parse_options failure "up".
>
> Grr. Somebody isn't following the nice rules we have and that git
> encourages: make a commit message be a nice "one-line header" with the
> more complete explanation separated by an empty line (and with nice
> line-breaks etc).
>

Sorry boss.  I had a nagging feeling I was doing the wrong thing about
not diving in and fixing that comment.  Not sure where I messed up
applying the email, but if I see that sort of thing in the future I'll
edit it by hand.

>
> There are other commits that don't follow the rules, btw: you've applied
> patches from others that have the rigth Sign-off's from the authors, but
> you should sign off yourself, not just ack them. By actually taking that
> thing and committing it, you're doing more than ack'ing somebody elses
> work.
>

Sure, long term misunderstand on my part.  Thanks for clearing this
up, I'll be sure to properly sign off in the future.

          -eric
