Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbXFUDV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbXFUDV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbXFUDVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:21:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:30814 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbXFUDVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bKPvbAwWYLQ+x+sAxjHo6qw3CNGbWwNoEORDFZaPkS8dFPzCDe8IiRYRXrrD478TTaoTZCLgW6ZZhUEkH6vB82jR9nFd4Y8/x5/SFzAQWmpfNi2sJxKHtJOU1GCvcCXWjY6LbsLi0o+RhSW3SJhEAftzqJsGZfYACHhIGAojXsw=
Message-ID: <787b0d920706202021t567b2fefu869a03ef76f245da@mail.gmail.com>
Date: Wed, 20 Jun 2007 23:21:49 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: JIT emulator needs
Cc: "William Lee Irwin III" <wli@holomorphy.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46797747.9020904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <20070619150824.GH11781@holomorphy.com>
	 <787b0d920706192016l660dd5b0mbf300581db81ac62@mail.gmail.com>
	 <20070620160116.GI6909@holomorphy.com> <467957CB.8020704@zytor.com>
	 <787b0d920706201125g2368a4e1i2d115b0b2d5399e5@mail.gmail.com>
	 <46797747.9020904@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Albert Cahalan wrote:
> > Putting this into the security policy was an error born of
> > lazyness to begin with. Abuse of the security mechanism
> > was easier than hacking the toolchain, ELF loader, etc.
> >
> > Either a binary needs self-modification, or it doesn't. This is
> > determined by the author of the code. If you don't trust an
> > executable that needs this ability, then you simply can not
> > run it in a useful way.
>
> That's fine.  That's a policy decision.  That's what a security policy
> *is*.  The owner of the system has decided, by security policy, that
> that is not allowed.  Bypassing that is not acceptable.

Fixing a bug should be acceptable.

Look, let's back up a bit here. At a high level, what exactly do
you imagine that this behavior was intended for? I suggest you
list some examples of the attacks that are blocked.

Can you come up with a reasonable argument that the current behavior
is the least painful restriction required to block those attacks?
Does the current behavior block any attack that the proposed behavior
would not? (list the attacks please)
