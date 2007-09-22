Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbXIVQH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbXIVQH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 12:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbXIVQHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 12:07:19 -0400
Received: from hu-out-0506.google.com ([72.14.214.229]:37937 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbXIVQHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 12:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cTg9kU4IquJFeAxuSl5fjEiyzdZQbLzr/ypnhGdJ+dp+lXLJ9l5rwMlFtFAlmMr36sia2cZF4pYRsr68NsulJ7Q3xE8+OlYLmyZKI4jNj8/HUeEaWal5rMMFJbboAEFMziguWsmlOYrpd3axM/EAKGyPJuwtqkk1qOSPpouCT6Y=
Message-ID: <517f3f820709220907l4c4e693di3df6942bdca5bcfa@mail.gmail.com>
Date: Sat, 22 Sep 2007 18:07:14 +0200
From: "Michael Kerrisk" <mtk.linux.lists@gmail.com>
To: "Bernd Eckenfels" <ecki@lina.inka.de>
Subject: Re: RFC: A revised timerfd API
Cc: linux-kernel@vger.kernel.org, "Ulrich Drepper" <drepper@redhat.com>,
       geoff@gclare.org.uk, "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@lst.de>, "Jonathan Corbet" <corbet@lwn.net>,
       "Randy Dunlap" <rdunlap@xenotime.net>, vda.linux@googlemail.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "=?ISO-8859-1?Q?David_H=E4rdeman?=" <david@hardeman.nu>,
       mtk-manpages@gmx.net
In-Reply-To: <E1IZ62P-0000EX-00@calista.eckenfels.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46F514C9.5010208@gmx.net>
	 <E1IZ62P-0000EX-00@calista.eckenfels.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bernd,

Please don't trim the CC list when replying!  I nearly did not see
your reply, and others will have missed it also.

On 9/22/07, Bernd Eckenfels <ecki@lina.inka.de> wrote:
> In article <46F514C9.5010208@gmx.net> you wrote:
> >  1. This design stretches the POSIX timers API in strange
> >     ways.
>
> Maybe it is possible to reimplement the POSIX API in usermode using the
> kernel's FD implementation?

It's a clever idea...  Without thinking on it too long, I'm not sure
whether or not there might be some details which would make this
difficult.

> (and drop the posix support from kernel)

However we couldn't drop POSIX support from the kernel, because that
would break the ABI.

Cheers,

Michael
