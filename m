Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbXKDNXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbXKDNXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 08:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbXKDNXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 08:23:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:50977 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbXKDNXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 08:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ueAuAdXe/pqXWsb9PGmSo3R7OdcGVKF7I5AfyQbLZdU9212/W9WZpW28PuU4yZxEqKenucJucj8UKc5OaiClMUI3PYZm2zscwI03YSavK0BMx3JKdbLJi6rcghPLSlRximX8NexMoh/la7Boc33tlmSZHjVCiwe+h8wZk3qt0Es=
Message-ID: <1865922a0711040523k2f3dac51k8db872169fd518e7@mail.gmail.com>
Date: Sun, 4 Nov 2007 15:23:06 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Cc: "Casey Schaufler" <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071104122848.GC3921@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
	 <20071104122848.GC3921@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > > Still to come:
> > >
> > >   - Final cleanup of smack_load_write and smack_cipso_write.
> >
> > Hi All,
> >
> > After agreeing with Casey on the "load" input grammar yesterday, here's
> > the final grammar and its parser (which needs more testing):
> >
> > A Smack Rule in an "egrep" format is:
> >
> > "^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*\n"
> >
> > where Subject/Object strings are in the form:
> >
> > "^[^/[:space:][:cntrl:]]{1,SMK_MAXLEN}$"
>
> Can we avoid string parsers in the kernel?
>

I've suggested that at first, but (hoping not to misquote Al) Al viro
said that the parsing is simple enough and no need exists for a
user-space utility.

>
> > +static inline int isblank(char c)
> > +{
> > +     return (c == ' ' || c == '\t');
> > +}
>
> This sounds like enough for 'NAK'.
>

Would you please show the reason for the NAK so I can modify the code ?

Thank you,

>                                                 Pavel,
>                 who still thinks smack rules should be parsed
>                 in userspace and compiled into selinux rules...
>

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
