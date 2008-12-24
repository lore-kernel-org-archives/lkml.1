Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbYLXGUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbYLXGUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 01:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYLXGUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 01:20:35 -0500
Received: from smtp-out.google.com ([216.239.45.13]:8911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYLXGUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 01:20:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=YBJoViTeW7sGTcXeRb4lUwrTcGeMElGoWIXsiHBfElZ0C9hjRb5LnPKisM6Cw0463
	NNUnG2Bsv/dS84qpkaVSQ==
MIME-Version: 1.0
In-Reply-To: <495190F7.1030708@kernel.org>
References: <86802c440812231328oa5e9682q9ad70a96680463b2@mail.gmail.com>
	 <20081223213630.GA5053@elte.hu>
	 <b040c32a0812231546s70cf651la19aec03fb9a308c@mail.gmail.com>
	 <b040c32a0812231707w7a1704c5y169b659a394ba2a7@mail.gmail.com>
	 <495190F7.1030708@kernel.org>
Date: Tue, 23 Dec 2008 22:20:27 -0800
Message-ID: <b040c32a0812232220l54e58e29w462f0ec57f83aeb3@mail.gmail.com>
Subject: Re: panic with tg_shares_up again?
From: Ken Chen <kenchen@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.37
X-GMailtapped: kenchen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 5:31 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > After a couple of hours joggling with type cast and different order in
> > which these two variables are checked, the compiler I'm using seems to
> > insist only check one byte out of sd_rq_weight.  I give up for the day
> > and removed the 'static' function declaration of
> > update_group_shares_cpu().  Without the 'static', the assembly looks
> > alright to me.
> >
> > I will ask compiler expert to see what's wrong with this code.  For
> > now, the following add on patch seems generate correct x86 assembly
> > code.
>
> maybe my compiler has some problem too?  just upgrade to opensuse 11.1 last week.
>
> yhlu@linux-mstp:~/xx/xx/kernel/tip/linux-2.6> gcc --version
> gcc (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291]
> Copyright (C) 2008 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

I'm shooting darts around, not sure what's going on yet.

- Ken
