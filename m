Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbYIQBXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbYIQBXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 21:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYIQBXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 21:23:33 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:35443 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752521AbYIQBXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 21:23:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BOUQJf8Lp/y0AKXr3PAO7re/VjlfEzcBXrQAlG7Ioh30pj8EcEZpVNVoaKspjRojcAjHHP4Q2Bf3477x81tcXGfyMqMlLI7hAOefhYVHmNf20PdfK3JVIGYo2m2GsYP9G09/wDoS4wfT3vvKugEyXAJTDdonnQxnVY15Czfs3KY=  ;
X-YMail-OSG: aTyCRKEVM1mt.Blxm47RWN1VKgkE.0dsHfO8.FpCR6LM7xgmoDJdTwEx5H75V805aI1hcJGtEhHnohptPn7wLBgFPlcH99.KjSMXjpvmYO6wF0r9DC4y9NNiSfQMeT8XwGIXYcJBqHDh1qXrPpdThygyaNWe_Emg
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ulrich Drepper <drepper@redhat.com>
Subject: Re: sys_paccept: disable paccept() until API design is resolved
Date: Wed, 17 Sep 2008 11:22:39 +1000
User-Agent: KMail/1.9.5
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>, Alan Cox <alan@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       netdev <netdev@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@lst.de>
References: <48CFA10D.2010106@gmail.com> <48D03E85.9030808@redhat.com>
In-Reply-To: <48D03E85.9030808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809171122.40442.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 09:17, Ulrich Drepper wrote:
> Michael Kerrisk wrote:
> > The patch below disables the new sys_paccept() for now.  Please
> > apply for 2.6.27-rc, so that we do not release this API into
> > the wild before a conclusion has been reached about its design.
>
> There is no reason for that.

There is a good reason, and that is that if there is any questioning
of a patch that adds a userspace API, then it is much better to be
safe than sorry.

We don't get enough people reviewing these things as is, so
ignoring the review we do get is not the right thing to do. There
is much more harm in releasing the kernel with a poor API than
just holding off for another release until issues are sorted out.
