Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbXJaKKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbXJaKKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbXJaKKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:10:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:47727 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbXJaKKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GMaUE4XxuXxxHJpbpVxrKkMqSGa55zPwl7rTAViOtiHq55GgBaVKjZ54MANFr2nhq2VCEte+mPg5wnI5aiBkxtscgzs4MDTYlfTgFI4LR9omekWL+xVJrcvZqWm9f+ieoSEKeMD603gKE1Z2yQq8iCqNfX1WQG84d+/OJmLVbbw=
Message-ID: <9d732d950710310310k4ddd1fefs1ba86e2baf936bb6@mail.gmail.com>
Date: Wed, 31 Oct 2007 19:10:29 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "Crispin Cowan" <crispin@crispincowan.com>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
Cc: "Peter Dolding" <oiaohm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <472823FA.80303@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>
	 <4726377A.4080807@crispincowan.com>
	 <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
	 <Pine.LNX.4.64.0710301136560.31325@fbirervta.pbzchgretzou.qr>
	 <4727C06A.4060005@gmail.com>
	 <Pine.LNX.4.64.0710301713260.8703@asgard.lang.hm>
	 <e7d8f83e0710301921m3460f8dfkce72c4fc549ded4a@mail.gmail.com>
	 <472823FA.80303@crispincowan.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/31, Crispin Cowan <crispin@crispincowan.com>:
> Peter Dolding wrote:
> > Lets end the bitrot.  Start having bits go into the main OS security
> > features where they should be.
> >
> Linus categorically rejected this idea, several times, very clearly.
>
> He did so because the security community cannot agree on a
> one-true-standard for what that OS security feature set should be. From
> looking at this thread and many others, he is correct; there is no
> consensus on what the feature set should be.
>
> So you can wish for the "main OS security features" all you want, but it
> is not going to happen without a miraculous degree of consensus abruptly
> arising.
>
> On the contrary, security, done well, is a tight fitting suit. It must
> be tight, or it allows too much slack and attackers can exploit that. To
> make it tight, it must be tailored to the situation at hand. That means
> that there may *never* be a consensus on the "one true way", because it
> could be that there is no "one true way". It could be that SMACK is best
> in some cases, AppArmor in others, SELinux in others yet again, MLS in
> others, etc. etc.
>
> I agree with Casey; LSM may not be perfect, but it is a great deal more
> consensus than I have seen anywhere else in the security community. Your
> desire that AppArmor and SELinux should share code has already happened:
> LSM *is* the sharable code base between AppArmor, SELinux, and SMACK and
> TOMOYO, and MultiADM, etc.

My main concern is whether we (different attempts) can share the code.
IOW whether we can reach and form the agreement for single security framework.
It is possible to write code if only we have a clear specifications, but
this is not the case.
I can easily think of LSM, or whatever we call,  as Greatest Common Factor,
but in that case LSM will explode soon and no single module can not be happy,
Linux security will not be achieved.

> It certainly can be improved, but it is not in need of wholesale
> replacement, and especially not without a clear design that addresses
> clearly stated problems that lots of people are having.

We should not invent wheels, that is agreed by everyone , but if we try to share
something that we can not share, we will fail. From the fact existing
LSM did not satisfy any module (including SELinux), I do not
want to investigate stack able version.

Cheers,
Toshiharu Harada
