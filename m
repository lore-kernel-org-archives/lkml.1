Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbXKDM3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbXKDM3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 07:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757804AbXKDM3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 07:29:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4199 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758267AbXKDM3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 07:29:15 -0500
Date: Sun, 4 Nov 2007 12:28:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071104122848.GC3921@ucw.cz>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071103164303.GA26707@ubuntu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Still to come:
> > 
> >   - Final cleanup of smack_load_write and smack_cipso_write.
> 
> Hi All,
> 
> After agreeing with Casey on the "load" input grammar yesterday, here's
> the final grammar and its parser (which needs more testing):
> 
> A Smack Rule in an "egrep" format is:
> 
> "^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*\n"
> 
> where Subject/Object strings are in the form:
> 
> "^[^/[:space:][:cntrl:]]{1,SMK_MAXLEN}$"

Can we avoid string parsers in the kernel?


> +static inline int isblank(char c)
> +{
> +	return (c == ' ' || c == '\t');
> +}

This sounds like enough for 'NAK'.

						Pavel,
		who still thinks smack rules should be parsed
		in userspace and compiled into selinux rules...
		
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
