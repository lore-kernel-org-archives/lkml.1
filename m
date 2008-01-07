Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYAGXWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYAGXWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYAGXV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:21:58 -0500
Received: from hs-out-0708.google.com ([64.233.178.242]:10925 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752993AbYAGXV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:21:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GJDHkV+U57X+zvaR7XmuYpyH8vqi8fB8M9eM+61uFwq8sZUNRGTihnlTvk0CeIvURg5VyF69c2VelYde7ZwUkTu24S7hqjqp1Ju/wVRpP8a0AN0ozTi3MEVlp1nffQCrAs2y3bYmwNR4lPLNqvmImS61JLaPqWg+ypT7JMJGt9E=
Message-ID: <82e4877d0801071521s607491f1ue25c4b97de47db71@mail.gmail.com>
Date: Mon, 7 Jan 2008 18:21:45 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200801062011.31491.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801052042.56042.rjw@sisk.pl> <200801061357.36324.rjw@sisk.pl>
	 <82e4877d0801060821r2ec43a9em6b4b6a8f763af7c8@mail.gmail.com>
	 <200801062011.31491.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 6, 2008 2:11 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> On Sunday, 6 of January 2008, Parag Warudkar wrote:
> > On Jan 6, 2008 7:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Sunday, 6 of January 2008, Ingo Molnar wrote:
> > > >
> > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > >
> > > > > Subject             : soft lockup - CPU#1 stuck for 15s! [swapper:0]
> > > > > Submitter   : "Parag Warudkar" <parag.warudkar@gmail.com>
> > > > > Date                : 2007-12-07 18:14
> > > > > References  : http://lkml.org/lkml/2007/12/7/299
> > > > >               http://bugzilla.kernel.org/show_bug.cgi?id=9525
> > > > > Handled-By  : "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
> > > > >               Thomas Gleixner <tglx@linutronix.de>
> > > > >               Ingo Molnar <mingo@elte.hu>
> > > >
> > > > i think this only occurs with cpuidle, right? drivers/cpuidle/ and
> > > > CPU_IDLE is new in 2.6.24 so this appears to be a bug in that code (or a
> > > > bug elsewhere triggered by that code), not a regression from v2.6.23.
> > >
> > > OK, removed from the regressions list.
> >
> > Nope - actually it did happen without CPU_IDLE so it is definitely a regression.
> > (See http://lkml.org/lkml/2007/12/17/93 )
> >
> > And it does happen with latest git which I believe has your patch Ingo.
> >
> > So I would suggest to keep it on the list of regressions.
>
> OK
>
> Thanks for the clarification.
>

BTW, I have so far tested 2.6.24-rc4/5/6/7 and 2.6.23.12 - all of
which have this problem.

Yesterday I went back to using 2.6.22.15 and after a day's uptime it
has not reproduced with the same config.

Time for git-bisect I suppose? (the only problem is that this takes
anywhere between 20 minutes to 8 hrs to confirm reliably.)

Parag
