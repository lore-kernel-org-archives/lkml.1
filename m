Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbYAFQVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbYAFQVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbYAFQVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:21:44 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:53737 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbYAFQVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:21:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OKeFJJ9MxH9bMOttjR11+bQ94R0lHd6xUHGatcqdtA2lfYP/hZEgI767vs9FSVZpcsNmnOBjlugwydd4VVqafgQCCjtVN/xBXoNf0JeQg9OoRIjSd9xACeX2Fr3z8cYB/XMSYrNov6ucNLktpSNgyPm8Krkzfw54ApWwO2w8Wqo=
Message-ID: <82e4877d0801060821r2ec43a9em6b4b6a8f763af7c8@mail.gmail.com>
Date: Sun, 6 Jan 2008 11:21:41 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200801061357.36324.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801052042.56042.rjw@sisk.pl> <20080106094504.GE26291@elte.hu>
	 <200801061357.36324.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 6, 2008 7:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, 6 of January 2008, Ingo Molnar wrote:
> >
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > > Subject             : soft lockup - CPU#1 stuck for 15s! [swapper:0]
> > > Submitter   : "Parag Warudkar" <parag.warudkar@gmail.com>
> > > Date                : 2007-12-07 18:14
> > > References  : http://lkml.org/lkml/2007/12/7/299
> > >               http://bugzilla.kernel.org/show_bug.cgi?id=9525
> > > Handled-By  : "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
> > >               Thomas Gleixner <tglx@linutronix.de>
> > >               Ingo Molnar <mingo@elte.hu>
> >
> > i think this only occurs with cpuidle, right? drivers/cpuidle/ and
> > CPU_IDLE is new in 2.6.24 so this appears to be a bug in that code (or a
> > bug elsewhere triggered by that code), not a regression from v2.6.23.
>
> OK, removed from the regressions list.

Nope - actually it did happen without CPU_IDLE so it is definitely a regression.
(See http://lkml.org/lkml/2007/12/17/93 )

And it does happen with latest git which I believe has your patch Ingo.

So I would suggest to keep it on the list of regressions.

Thanks

Parag
