Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbXKKSh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbXKKSh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 13:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbXKKShO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 13:37:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:61469 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbXKKShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 13:37:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gshNkrkMZjNaZchxcgcDf8XG/IqDEJbJ3yHsXBsNz8OXR46fDIwz58cVIaEnGCGiWx4aabG8XKX4RvGanxIbsSzgG6ETZ3MnCZsbf5Gsn9MZToTxtzA7LWlB30AZh+1uoJQhC84bjJtJgKvVaHDuvLJDDlJvk6iqgGODXqNXgG0=
Message-ID: <1865922a0711111037q6a58e607m1c7f4eacf0daef96@mail.gmail.com>
Date: Sun, 11 Nov 2007 20:37:11 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser(2)
Cc: "Casey Schaufler" <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Al Viro" <viro@ftp.linux.org.uk>
In-Reply-To: <20071111124409.GA5141@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
	 <20071105005625.GA18030@ubuntu> <20071111124409.GA5141@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Nov 11, 2007 2:44 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > > A Smack Rule in an "egrep" format is:
> > >
> > > "^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*\n"
>
> Perhaps you should make it space, not 'space or tab', and only allow
> lowercase permissions? That way, parser will be slightly simpler, and
> you'll still have a chance to use 'R' as 'slightly different r'.
>

Thanks for your care about this. It seems not a lot of people have
noticed, but to stop any objections not related to the core smack
code, Casey decided to let the parsing be done in a user-space utility
that sends the rules to the kernel in a predefined strict format.

You can find how the whole story in the smackv11 announcement here:
http://article.gmane.org/gmane.linux.kernel.lsm/4463

Regards,

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
