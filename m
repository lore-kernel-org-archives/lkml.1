Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbXKKNA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbXKKNA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 08:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXKKNAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 08:00:14 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3869 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754131AbXKKNAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 08:00:13 -0500
Date: Sun, 11 Nov 2007 12:44:10 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser(2)
Message-ID: <20071111124409.GA5141@ucw.cz>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071105005625.GA18030@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105005625.GA18030@ubuntu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > A Smack Rule in an "egrep" format is:
> > 
> > "^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*\n"

Perhaps you should make it space, not 'space or tab', and only allow
lowercase permissions? That way, parser will be slightly simpler, and
you'll still have a chance to use 'R' as 'slightly different r'.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
