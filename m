Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbYASO5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbYASO5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbYASO5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:57:31 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:64522 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbYASO5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:57:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fYyb1qLZehmvxKBoAv698UwEz/aBuu2kLFK8678mVmIWSINeLPTOB5wBuohw49QnQ1IQV9TGRR/ChUrokuF1xjvMypyymHNSXuFOEs0hf8QDItLmpD74FUErEjWb3N6FX6KjNuTb2bQcafbE0EshOh4+k6UowY9dAXrUYW8UB8k=
Message-ID: <ee3dc96c0801190657x54edb8cve8a4c09a6efbbb2a@mail.gmail.com>
Date: Sat, 19 Jan 2008 11:57:29 -0300
From: "Rafael Sisto" <rafael.sisto@gmail.com>
To: "Rafael Sisto" <rafael.sisto@gmail.com>,
       "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: new file in kernel.
In-Reply-To: <20080119143051.GB9896@lug-owl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com>
	 <20080119134837.GA15610@ghostprotocols.net>
	 <ee3dc96c0801190621p1970086fj218178a7519fe4af@mail.gmail.com>
	 <20080119143051.GB9896@lug-owl.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jan,
I wrote a mail 10 hours ago with the subject "create a file in kernel
mode. help please!" explaining what I want to do but nobody answered,
so I decided to write a short mail with a specific question.

I don't doubt there's a much cleaner and better way to do it, because
I am a beginner in kernel programming...

The thing is, it is for a college project. we have to build something
like IPC, but simpler. we have a "get" system call (we thought we
would just create a file in /tmp, not use it from the kernel, just
create it) and then the users that want to access the shared memory
will call the system call "attach". That will map the file into user
space, as shared.

The problem is that we are not successfuly creating the file, and when
some user calls the system call "attach" and then uses the memory, he
gets a "Bus Error" message. (We tried creating the file not with a
system call, but with "vi", then calling our system call "attach" to
the file created, and it worked fine)

So, my question is how to successfully create a file in kernel mode,
for later use... (I read the implementation of IPC, and it seems they
create a file in tmpfs, on the "get" system call, so my idea was to do
something similar)

I hope it is much clearer now, and would gratefuly accept any answer,
with new ideas, or an approach to make me realise what I am doing
wrong..

Thanks in advance,
Greetings, Rafael Sisto.


On Jan 19, 2008 11:30 AM, Jan-Benedict Glaw <jbglaw@lug-owl.de> wrote:
> On Sat, 2008-01-19 11:21:11 -0300, Rafael Sisto <rafael.sisto@gmail.com> wrote:
> > Dear Arnaldo, I didnt see your mail before.
> > I read some of the code you suggested, but it seems so complicated! I
> > just need to create a file named "file" on the path /tmp/.. Isn't
> > there an easier way?
>
> In my opinion, you're heading totally into the wrong direction. Nobody
> will help you solving your problem with a given fixed method (file
> accessing in kernel mode) unless you describe your problem in detail.
>
> There's probably a much better and cleaner way. But unless you
> describe your application and the overall goal in detail, please don't
> expect too much help.
>
> MfG, JBG
>
> --
>       Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
>   Signature of:                           Wenn ich wach bin, träume ich.
>   the second  :
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
>
> iD8DBQFHkgmbHb1edYOZ4bsRAmvTAJ0RXMAnOfFUApNNaPO7Gl+pdkrUvwCcDsJd
> +hpuhG9WunLb5rIAlwvWP6Q=
> =Orr2
> -----END PGP SIGNATURE-----
>
>
