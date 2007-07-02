Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXGBNBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXGBNBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbXGBNBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:01:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:54139 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbXGBNBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q2RUXMyQvG3TSMDMJh5/lLjCloF+IgwqnRTWchn12kmBGN267D+pVdOA3KTENrh/YyIZMBaXb3N5sK2mIiT9HZ2a5y4zxVHl4QE1djsIhd6Vr5JqECidhf5OAcSDF4QfCE01z711EIzXacr0FOsEaJPTtU8KlOwL/KxqLcCx7g8=
Message-ID: <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com>
Date: Mon, 2 Jul 2007 15:01:37 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [patch] CFS scheduler, -v18
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622220202.GA16872@elte.hu>
	 <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/07, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hello,
>
> On 6/23/07, Ingo Molnar <mingo@elte.hu> wrote:
> > i'm pleased to announce release -v18 of the CFS scheduler patchset.
>
> > As usual, any sort of feedback, bugreport, fix and suggestion is more
> > than welcome!
>
> I have been running cfs-v18 for a couple of days now, and today I
> stumbled upon a rather strange problem. Consider the following short
> program:
>
> while(1)
>         printf("%ld\r", 1000 * clock() / CLOCKS_PER_SEC);

Is it running with a default (0) nice value?

could you please run the following script when your application is running?
As you have pointed out :

"... In fact, it seems that the longer it runs, the longer it takes to
terminate (towards 5 seconds after running for a couple of minutes
..." ,

please run the script a few times : say, before starting up your
application, 10 sec. after it's got started, 1 minute, a few minute...

http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

then send us the resulting files. TIA,


-- 
Best regards,
Dmitry Adamushko
