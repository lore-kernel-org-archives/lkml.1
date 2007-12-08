Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbXLHUrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbXLHUrq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbXLHUq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:46:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:20937 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbXLHUqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:46:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iCrv66xfBiNBvyqVjFmE7MiUuzh6n1BXU7jRXVeeLFTmGpc1EmSlDmhs4B9Mu/vWoUlc1Gb5q8aMfax7TFTBu8dhW0wDSODgIXUV5eFNAN3EXdNGuBGA3AUpqLRU9+qYeDJw9RAko1CxBoKaZIOp6lnH+FQhAc6w/L6nDcMLkaQ=
Message-ID: <82e4877d0712081246x4d788c36i908916185611fa94@mail.gmail.com>
Date: Sat, 8 Dec 2007 15:46:54 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20071208201137.GA13451@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <82e4877d0712080710g205ba93ag12ee204b15d70fdb@mail.gmail.com>
	 <82e4877d0712080736v12c1e31at9149655ae000fe50@mail.gmail.com>
	 <20071208154755.GA5255@elte.hu>
	 <82e4877d0712080800j6572734ek78a76cf7bb17a7e0@mail.gmail.com>
	 <20071208191330.GA21186@elte.hu>
	 <82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com>
	 <20071208194211.GA579@elte.hu>
	 <82e4877d0712081208u335c968csd1d3e9259cdd2920@mail.gmail.com>
	 <20071208201137.GA13451@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 8, 2007 3:11 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Parag Warudkar <parag.warudkar@gmail.com> wrote:
>
> > But there are still fluctuations under 100% idle -
>
> do you have CONFIG_HIGH_RES_TIMERS=y?

Yes - NO_HZ=y  and HIGH_RES_TIMERS=y.
My ssh connection still died with hpet=disable although this time I
did not see soft lockup message.
Also it randomly gets stuck - suddenly there is a freeze and I can't
type for seconds.

> these fluctuations would still be OK if they are due to HZ granularity.
>

So are the hpet ones ok too or do they seem off even with HRTIMERS=y?
Just trying to figure out if I should be testing further with hpet
disabled or enabling it is ok.

Parag
