Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZBAB1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZBAB1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZBAB04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:26:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:60446 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZBAB0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:26:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=eoNYgF+++vpD8psXrb+SgqbbcwIuH7CEuepxe6j0hxT61sDXtikj2r9zHLk2FJwutO
         8QWibRcRZi0F4wEZi7q4UitnN9XSuRu6LgBOzF4kQQsvmKznMIlDz0v68lX/9Nyl9m78
         pYcomrnc87QHrUChZ+nZHumBvDdUqhVRu30b8=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0901291053580.15448@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com>
	 <20090129005716.6dd51929.akpm@linux-foundation.org>
	 <cfd18e0f0901290203r139cb5bfgc02a0dcb1347aba8@mail.gmail.com>
	 <alpine.DEB.1.10.0901291053580.15448@alien.or.mcafeemobile.com>
Date: Sun, 1 Feb 2009 14:26:53 +1300
Message-ID: <cfd18e0f0901311726n439d3034qa87f3ab31acd4858@mail.gmail.com>
Subject: Re: [patch] drop epoll max_user_instances and rely only on 
	max_user_watches
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>,
       Bron Gondwana <brong@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

On Fri, Jan 30, 2009 at 7:54 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Thu, 29 Jan 2009, Michael Kerrisk wrote:
>
>> Since max_user_instances was added in 2.6.28, and this is an ABI
>> change, I suggest this should go into .29-rc, so that
>> max_user_instances spends as little time in the wild as possible.
>
> Agreed, like I already told Andrew. Sorry Michael for the double change to
> the man page :/

So is the right change to the epoll(7) page (see
http://www.kernel.org/doc/man-pages/online/pages/man7/epoll.7.html )
to simply remive the text on max_user_instances:

       /proc/sys/fs/epoll/max_user_instances (since Linux 2.6.28)
              This  specifies  an  upper  limit on the number of epoll
              instances that can be created per real user ID.

Or are other changes also required?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
