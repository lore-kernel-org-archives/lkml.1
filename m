Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbZHATTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbZHATTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 15:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZHATTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 15:19:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35170 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbZHATTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 15:19:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Bug report (suspend to disk is broken in 2.6.29+ with EIDE drive)
Date: Sat, 1 Aug 2009 21:19:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Andrew Watts <akwatts@ymail.com>, linux-kernel@vger.kernel.org,
       bzolnier@gmail.com, ide <linux-ide@vger.kernel.org>
References: <937390.49428.qm@web111003.mail.gq1.yahoo.com> <4A748B27.3000902@gmail.com>
In-Reply-To: <4A748B27.3000902@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908012119.46522.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 August 2009, Robert Hancock wrote:
> On 07/31/2009 12:22 AM, Andrew Watts wrote:
> > Description: s2disk worked in 2.6.28 and no longer works in 2.6.30.2
> > (s2disk here means: echo disk>  /sys/power/state); screen blanks but
> > system hangs.
> >
> > Bisection reveals that the problem commit has hash:
> > 295f00042aaf6b553b5f37348f89bab463d4a469.
> 
> That would be:
> 
> author	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 	Fri, 2 Jan 2009 15:12:48 +0000 (16:12 +0100)
> committer	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 	Fri, 2 Jan 2009 15:12:48 +0000 (16:12 +0100)
> commit	295f00042aaf6b553b5f37348f89bab463d4a469
> tree	cbd56955f148f0e175d5b6b779c2888bf2645382
> parent	ebdab07dad3d3a008e519b0a028e1e1ad5ecaef0
> 
> ide: don't execute the next queued command from the hard-IRQ context (v2)
> 
> CCing Bart and linux-ide.

Bart says that should be fixed by commit
2ea5521022ac8f4f528dcbae02668e02a3501a5a, which also is present in
2.6.29, so the bisection result is likely a false positive.

Thanks,
Rafael
