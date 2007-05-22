Return-Path: <linux-kernel-owner+w=401wt.eu-S935587AbXEVWPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935587AbXEVWPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761717AbXEVWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:15:34 -0400
Received: from web52612.mail.re2.yahoo.com ([206.190.48.215]:32194 "HELO
	web52612.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761351AbXEVWPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:15:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=PAq6gy6jGQ/Gnp0TKSOspLMd4kfMNWvJbueJkO4aH/brMSBW7i4Qd6GeGGoT0gYEf/3+HcpM1pF3Y+01biwshgnvA5Z1R45CCz8mAstWGk6qzzOXyhCA7xnsPYz/q/LFN5yaQPZYAVKZgCUGLsQmCktk1+xAM2xJubi1lupkrys=;
X-YMail-OSG: vx4AJm0VM1ltgB9oS8aUrx3dY0.RLVzb28o2kPrUjuOeR0mK3C3U_rg1kQ_NzrqJew5qjI1fAtsT0dUMctMl16HZb7uAJO1Y_Dn60FQn2B.bhDBNvKi1L5E5_0PWJ0iP6lu74fOof__Nrmk-
Date: Wed, 23 May 2007 08:15:30 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Hugh Dickins <hugh@veritas.com>, Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705221358360.4904@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <376320.95285.qm@web52612.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Hugh Dickins <hugh@veritas.com> wrote:
> On Tue, 22 May 2007, Srihari Vijayaraghavan wrote:

[...]

> > Compiled slub with SMP & CONFIG_PROVE_LOCKING. No luck. It still hangs
> solid

[...]

> You've made no mention of trying the patch I sent yesterday, or better,
> the patch Christoph replied with to replace it.  Please clarify whether
> you're getting the above after applying one of those patches - thanks.

Sorry about that :-(. Was a busy day & skipped a few emails :-(.

Indeed with Christoph's patch (over the hg commit 57109:745e2df8ec60), without
CONFIG_SLUB_DEBUG, but with CONFIG_PROVE_LOCKING only under the kernel
debugging section, on CONFIG_SMP the slub kerenel is quite stable. (It's
running some stress tests now, but things are looking good.)

(If you want me to test it with other slub or kernel debug options please let
me know. It just takes a lot of time to eliminate the variables, if there are
problems.)

Thanks folks.



      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

