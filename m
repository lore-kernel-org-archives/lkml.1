Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab0BER7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:59:36 -0500
Received: from web55004.mail.re4.yahoo.com ([206.190.58.138]:39798 "HELO
	web55004.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757228Ab0BER7f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:59:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=B1jTIl5TzCgJMJ6L5Q/8KEun+Mi5Cd9n002TUBtKkhjYUAMxGn/ZriYhPvrzvmcIQWGlyf4OKlwJMRvDrKnNhCRgHmFALTRmrqSCvChzHCyFVtmcz6myGNbmqCa4eeAY534q4Jm6alsSKkgRWrEK8xpcy+nvQecW5Qd4QRBLojM=;
Message-ID: <726303.26036.qm@web55004.mail.re4.yahoo.com>
X-YMail-OSG: Dp9jZt8VM1lmQYWluSrmblBGLuiq3SfCl52g7O.3L2dTviCJkGYaf3S5c_ZXz3iCY9KQTUm1NB21FILgzvLHuOObNm2NtW6M4npFWkY_4aAccbaUWN1MzwQyEBnqOxuSVNqzD9eiaNvkLABTlLF2MZrlRM5OScPw.PoaJBfLr2A05U5kYxkE0L.z3.d_F5t7vvqNtZev9IwZ1FWmu0s1rnB379X1tbwbpGyey6iJq.Q4DJNKeTkeB543VgKad4AhNCpvHnCCSGfYqwSJ0BJgK2Pulmn2WAp6yF5l6zQ8JR9A1vgIxzyvvL.VQG5PpLDsNNPlXc6Q6MIcLMONux.8
X-Mailer: YahooMailClassic/9.1.10 YahooMailWebService/0.8.100.260964
Date: Fri, 5 Feb 2010 09:59:34 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to get to performance counters
To: Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100205154748.GA11469@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So this patch got accepted into mainline a while ago,
> without a user
> ever beeing presented, nevermind actually included in
> mainline.  Time
> to revert providing these useless exports and dead code?

I think kernel perf api is very useful for improving kernel (modules) performance, and of course, for this purpose their usage won't make it into the distribution code.
I started to use them but still I would like to see an example showing its full potential (cpufreq was proposed).

Imagine moving structure's fields around for increasing cache performance, the general perf counters are, hmm, too general when we need to monitor only some code sections (after being identified using the global perf counters/tool).

John

--- On Fri, 2/5/10, Christoph Hellwig <hch@infradead.org> wrote:

> From: Christoph Hellwig <hch@infradead.org>
> Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to get to performance counters
> To: "Arjan van de Ven" <arjan@infradead.org>
> Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org, "Frederic Weisbecker" <fweisbec@gmail.com>
> Date: Friday, February 5, 2010, 7:47 AM
> On Fri, Sep 25, 2009 at 12:25:56PM
> +0200, Arjan van de Ven wrote:
> > >From 5db5cd76f3c16c9f6093f54d1ccfb97d04b9a1ca Mon
> Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Fri, 25 Sep 2009 12:20:57 +0200
> > Subject: [PATCH] perf_core: provide a kernel-internal
> interface to get to performance counters
> 
> So this patch got accepted into mainline a while ago,
> without a user
> ever beeing presented, nevermind actually included in
> mainline.  Time
> to revert providing these useless exports and dead code?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


      
