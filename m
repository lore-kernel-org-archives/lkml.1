Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYBCWmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYBCWmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYBCWmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:42:13 -0500
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:45152 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751630AbYBCWmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:42:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=MOE4XiLUnMl3xGq1F5lPvnI7v4zEQRuwfG5OqU7LBVuceHTkeLhoW6LZ0SciEFdKi9Yrj2EIw1MFr7NZCIF2u/N3gSicpDFwB4fCSDaoIAyBBYx7XzZi83O6OKbPTTaO4vgL4Qpbdnyhi1P5mjL9YaTjepMFzr6BnABzrTEsrLs=  ;
X-YMail-OSG: RN7_kMUVM1luEIXQMO10lvJlO8jQSDBsIXTZpU5bNtYpQHftGQenC0.O_pt29grZYVYyKMvn7g--
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 03 Feb 2008 14:42:06 -0800
From: David Brownell <david-b@pacbell.net>
To: rjw@sisk.pl
Subject: Re: [linux-pm] sleepy linux self-test
Cc: pavel@ucw.cz, mingo@elte.hu, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20080130131748.GA3796@elf.ucw.cz>
 <200802031321.27828.rjw@sisk.pl>
 <20080203131636.4100828D3E1@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <200802032229.30576.rjw@sisk.pl>
In-Reply-To: <200802032229.30576.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080203224206.8FD40166811@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > See the appended; it includes more of Ingo's suggestions.
> > 
> > Since this is increasingly unrelated to the "sleepy linux" concept
> > (a version of what systems like OLPC, N700, and N800 are doing), I
> > got rid of the "sleepy.c" file.
>
> The changes look good to me.

They feel unfinished to me though.  :)

Like using "jiffies" instead of a clocksource, which makes trouble
since the timing covers periods with IRQs disabled.  And the test
mode parameter needs work.


> Well, it would be nice to have this feature in as soon as reasonably possible,
> so that people can include suspend tests in the automated testing.

Except ... "rtcwake" (from util-linux-ng) already supports such
testing, albeit from userspace.   But not the timing tests.

What was the rationale for wanting this done in-kernel?  (Other
than to know it can work portably.)

- Dave

