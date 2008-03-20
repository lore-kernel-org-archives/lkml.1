Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYCTQ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYCTQ1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 12:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYCTQ11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 12:27:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4176 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753148AbYCTQ10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 12:27:26 -0400
Date: Thu, 20 Mar 2008 17:27:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ptrace: it is fun to strace /sbin/init
Message-ID: <20080320162718.GA4397@ucw.cz>
References: <20080316155455.GA20848@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316155455.GA20848@tv-sign.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ptracing of /sbin/init is not allowed. Of course, this is very dangerous, but
> may be useful. Introduce the kernel boot parameter to allow this.
...
> @@ -803,6 +803,8 @@ and is between 256 and 4096 characters. 
>  			Run specified binary instead of /sbin/init as init
>  			process.
>  
> +	init_ptrace	[KNL] Allows to ptrace init. Very dangerous. Don't use.
> +

I don't know what ptracing init is good for, and I believe people
wanting to do this kind of special stuff can patch their own kernel...


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
