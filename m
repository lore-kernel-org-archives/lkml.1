Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZA2KDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZA2KDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZA2KDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:03:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:23688 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbZA2KDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:03:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=n5lJnYJ3vCLPYKvbDNYkruJBnenTezS5ocw9oixGr+3AAuSIzL2KTT9Jxvyz2suoKe
         f9rUrif0KNcX84GTOSC9pHIessH6N4qnY6r6CsqRTmwOE1jayFHg5g56JOWHfvi1wK+R
         cQ+fy7X/a2uEFponwBF/JwDbJCSvCsBgarYKY=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20090129005716.6dd51929.akpm@linux-foundation.org>
References: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com>
	 <20090129005716.6dd51929.akpm@linux-foundation.org>
Date: Thu, 29 Jan 2009 23:03:37 +1300
Message-ID: <cfd18e0f0901290203r139cb5bfgc02a0dcb1347aba8@mail.gmail.com>
Subject: Re: [patch] drop epoll max_user_instances and rely only on 
	max_user_watches
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>,
       Bron Gondwana <brong@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 9:57 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>> Subject: [patch] drop epoll max_user_instances and rely only on max_user_watches
>
> nanonit: please prepare titles in the form "subsystem-id:
> what-i-did-to-it", so a suitable name here would be
>
>        epoll: drop max_user_instances and rely only on max_user_watches
>
> On Wed, 28 Jan 2009 20:56:07 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
>
>> Linus suggested to put limits where the money is, and max_user_watches
>> already does that w/out the need of max_user_instances. That has the
>> advantage to mitigate the potential DoS while allowing pretty generous
>> default behavior.

[...]

> I assume that because you based all this on all the other patches, you
> view it as 2.6.30 material?

Since max_user_instances was added in 2.6.28, and this is an ABI
change, I suggest this should go into .29-rc, so that
max_user_instances spends as little time in the wild as possible.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
