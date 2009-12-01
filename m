Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZLAI4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZLAI4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZLAI4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:56:36 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52709 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbZLAI4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:56:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pTYAT+ixvnoh99iW04KH+OqPlQOKy6q0krR2/C7ab8gXU+9vQkXadHHkyw+JkMdsz7
         RJcj7qYPKh7JucZsactmPUK8HFuEoCbcC0Q6hN+4iT2ntO+8H47cBpTQ5YY5bY8NoXa2
         AhdhBPMu+4emuBR4fXyGrzG++S4Mb6L23mzEo=
MIME-Version: 1.0
In-Reply-To: <20091130190030.GA5560@shareable.org>
References: <20091123173616.75c3f600@tlielax.poochiereds.net>
	 <20091123181545.05ad004d@tlielax.poochiereds.net>
	 <m1ljhwbyr3.fsf@fess.ebiederm.org>
	 <20091123193426.55f1530a@tlielax.poochiereds.net>
	 <20091124012027.GA14645@shareable.org>
	 <20091124062621.744beddb@tlielax.poochiereds.net>
	 <E1NCtxF-0000rn-1z@pomaz-ex.szeredi.hu> <20091124120906.GA1700@ucw.cz>
	 <e9e943910911240513g31e633ffg2e878a874f1110ba@mail.gmail.com>
	 <20091130190030.GA5560@shareable.org>
Date: Tue, 1 Dec 2009 08:56:40 +0000
X-Google-Sender-Auth: 36f8b96a27684b8a
Message-ID: <e9e943910912010056r6028b2c0u2474d7c0359acd0d@mail.gmail.com>
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks and 
	file bind mounts (try #5)
From: Duane Griffin <duaneg@dghda.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Pavel Machek <pavel@ucw.cz>, Miklos Szeredi <miklos@szeredi.hu>,
       Jeff Layton <jlayton@redhat.com>, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/30 Jamie Lokier <jamie@shareable.org>:
> Duane Griffin wrote:
>> 2009/11/24 Pavel Machek <pavel@ucw.cz>:
>> > On Tue 2009-11-24 12:53:09, Miklos Szeredi wrote:
>> >> I still believe leaving the current semantics and documenting them is
>> >> the best option.
>> >
>> > I believe that current semantics is ugly enough that 'documenting' it
>> > is not enough... and people want to port from other systems, too, not
>> > expecting nasty surprises like this...
>>
>> Solaris 10 works the same way as Linux does now, so I don't think the
>> porting argument gets you anywhere.
>
> It certainly must be similar, as gnulib uses the same technique on
> both Solaris and Linux.
>
> I don't have a Solaris to try this on.  Can you use /proc to re-open
> with O_RDWR a file descriptor previously opened with O_RDONLY on
> Solaris 10, assuming the underlying inode allows writing?

Yep, I basically followed Pavel's recipe and got the same result. On
the other hand, it didn't work on AIX.

> -- Jamie

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
