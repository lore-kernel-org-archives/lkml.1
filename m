Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYGAUh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYGAUh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbYGAUhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:37:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59935 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbYGAUhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:37:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Date: Tue, 1 Jul 2008 22:39:43 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200807010148.02135.rjw@sisk.pl> <20080701063133.GC16642@elte.hu> <4869D4A3.3020000@zytor.com>
In-Reply-To: <4869D4A3.3020000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807012239.44105.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> >> Hi,
> >>
> >> The appended patch fixes a regression and is considered as 2.6.26 
> >> material. Everyone having a box with working suspend to RAM is gently 
> >> requested to test it and verify if it doesn't break things.
> >>
> >> The patch applies to the current -git.
> > 
> > it's been under testing in tip/out-of-tree for about a week:
> > 
> > | commit ee901dc1b9ab94a37ba2efc296fe9ba72bc75adf
> > | Author:     H. Peter Anvin <hpa@zytor.com>
> > | AuthorDate: Tue Jun 24 23:03:48 2008 +0200
> > | Commit:     Ingo Molnar <mingo@elte.hu>
> > | CommitDate: Wed Jun 25 18:48:13 2008 +0200
> > |
> > |     x86 ACPI: normalize segment descriptor register on resume
> > 
> > no problems caused by it so far.
> > 
> 
> Here is the incremental patch which should stick "strictly to the 
> script" of ljmp immediately after writing CR0.PE.  This should be done 
> to the boot code as well; I'm waiting for confirmation from the Elan 
> original reporter before submitting that patch.
> 
> I decided to make this an incremental patch to make it bisectable versus 
> the other one, however, it should probably be considered the right thing.
> 
> Note: I have not tested this beyond compilation, I'm afraid.

I have tested it on the nx6325 (64-bit) on top of the today's linux-next.  It
works fine for me.

Thanks,
Rafael
