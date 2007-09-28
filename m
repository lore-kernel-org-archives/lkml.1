Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbXI1JuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbXI1JuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbXI1JuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:50:07 -0400
Received: from sargon.lncsa.com ([212.99.8.251]:56136 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbXI1JuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:50:06 -0400
Message-ID: <46FCC87A.3060004@lncsa.com>
Date: Fri, 28 Sep 2007 11:25:14 +0200
From: Laurent CARON <lcaron@lncsa.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Stefan Seifert <nine@detonation.org>
CC: Hannes Dorbath <light@theendofthetunnel.de>, linux-kernel@vger.kernel.org,
       drbd-user@linbit.com, Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [DRBD-user] Crash on 2.6.22
References: <46FCC2BE.7020509@lncsa.com> <46FCC3E4.7030908@theendofthetunnel.de> <46FCC7A2.8090506@detonation.org>
In-Reply-To: <46FCC7A2.8090506@detonation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Seifert wrote:
> The deadlock also occures with 0.7.x. A patch for that is floating around.

Here is a transcript from a mail I sent to Lars Ellenberg

It should 'normally' be fixed.

Am I wrong ?

Thanks



On Sun, Sep 16, 2007 at 05:34:01PM +0200, Laurent CARON wrote:
> > Lars Ellenberg a écrit :
>> > >On Fri, Sep 14, 2007 at 12:33:01AM +0200, Laurent CARON wrote:
>>> > >>Hi,
>>> > >>
>>> > >>After reading the thread about XFS, drbd 8.0.5 and 2.6.22+
kernels (XFS
>>> > >>filesystem locks on mounting with 0.8.0.5), i wonder if the same
applies
>>> > >>to using 0.7.24 and 2.6.22+.
>> > >
>> > >basically, yes.
>> > >so either don't use 0.7 with the kernels showing this behaviour,
>> > >or wait for some maintenance release,
>> > >or patch it yourself.
> >
> >
> > You said that this is fixed in the latest 8.x SVN.

it is fixed in 8.0.6

> > It is fixed in the latest 0.7.x SVN too ?

now, since you are so pushy today  :)
I just checked in something (r3062),
which should do the job, but is untested by me so far.
please test and report back.
