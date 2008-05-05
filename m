Return-Path: <linux-kernel-owner+w=401wt.eu-S1761894AbYEEVge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894AbYEEVge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbYEEVgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:36:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:17300 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbYEEVgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=v56jVORm8aHvjGIPWPFHvSKF+ymaB31ufLzbV+yFYxwx9azK1RuoIJltvPi9Zh6TMn22M+3Qvjnqcy88LY7Rku3kaIX5vj74c4qPYDIPuxQ/tGliQB/GxlWEhCOtieI2h8mN5lGtUwt9QDd4TSQIOatktaCGmdMNLuWG99lJAg4=
Message-ID: <82e4877d0805051436u377bf943m3beef5e9be5cbe23@mail.gmail.com>
Date: Mon, 5 May 2008 17:36:23 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <20080505172146.GB22332@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com>
	 <20080504092417.GA3425@elte.hu>
	 <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com>
	 <20080505172146.GB22332@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 1:21 PM, Ingo Molnar <mingo@elte.hu> wrote:

>  does -git boot fine - or is this a regression relative to v2.6.25?
>
>  I just built your config on latest sched-devel and booted it on two
>  64-bit testboxes and it boots just fine.
>
>  could you send your -git bootup log?

Hmm - It's the IO_DELAY stuff - I will test more but it looks like
with CONFIG_IO_DELAY_TYPE_NONE -git boots fine on my machine but with
the same option sched-devel does not.
Setting CONFIG_IO_DELAY_TYPE=0 (0x80) makes sched-devel boots again.

Parag
