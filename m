Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbZKXNN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbZKXNN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932882AbZKXNNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:13:54 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:54206 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbZKXNNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qQMk5XqcbhJc0Pp64nJ9/atUe0i/hvDgsThUBv4qyQvyZ8tCbJ23jUC0vDGMFj2yN7
         Lk40TgxQEy3Eldun1RhFqbZoOAeZGpap+CgRD4l+RxWtjKS1Rt1tyeCW7C/gs1NZ0sgG
         dAg3HM+psYD025S1Vr1+ql25KkQJJFV6lcCB0=
MIME-Version: 1.0
In-Reply-To: <20091124120906.GA1700@ucw.cz>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
	 <20091123173616.75c3f600@tlielax.poochiereds.net>
	 <20091123224948.GB5598@shareable.org>
	 <20091123181545.05ad004d@tlielax.poochiereds.net>
	 <m1ljhwbyr3.fsf@fess.ebiederm.org>
	 <20091123193426.55f1530a@tlielax.poochiereds.net>
	 <20091124012027.GA14645@shareable.org>
	 <20091124062621.744beddb@tlielax.poochiereds.net>
	 <E1NCtxF-0000rn-1z@pomaz-ex.szeredi.hu> <20091124120906.GA1700@ucw.cz>
Date: Tue, 24 Nov 2009 13:13:58 +0000
X-Google-Sender-Auth: f9798914fb23a648
Message-ID: <e9e943910911240513g31e633ffg2e878a874f1110ba@mail.gmail.com>
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks and 
	file bind mounts (try #5)
From: Duane Griffin <duaneg@dghda.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@redhat.com>,
       jamie@shareable.org, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/24 Pavel Machek <pavel@ucw.cz>:
> On Tue 2009-11-24 12:53:09, Miklos Szeredi wrote:
>> I still believe leaving the current semantics and documenting them is
>> the best option.
>
> I believe that current semantics is ugly enough that 'documenting' it
> is not enough... and people want to port from other systems, too, not
> expecting nasty surprises like this...

Solaris 10 works the same way as Linux does now, so I don't think the
porting argument gets you anywhere.

>                                                                Pavel

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
