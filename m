Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbYA1PEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbYA1PEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYA1PEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:04:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35204 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYA1PEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:04:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Q: x86 suspend/hibernation code consolidation
Date: Mon, 28 Jan 2008 16:01:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
References: <200801260132.09529.rjw@sisk.pl> <20080128140350.GB27928@elte.hu>
In-Reply-To: <20080128140350.GB27928@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281601.41651.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > I'd like to move the 64-bit suspend/hibernation files from 
> > arch/x86/kernel to arch/x86/power, modify the names of the 32-bit 
> > files already in arch/x86/power and update the Makefiles accordingly, 
> > but there are some changes queued for merging that touch the files in 
> > question.
> 
> nice cleanup.
> 
> > When is the right time for making changes like that?
> 
> best would be after the x86.git merge. We could push this via x86.git in 
> fact, to line it up with whatever other changes there might be. -mm 
> would be fine too, if there are pending patches in this area in -mm.

There is one patch in acpi.git, AFAICS, so I guess I'd have to wait for both
x86.git and acpi.git with that, which means -rc1 time frame more or less.
 
> (and i recall you did some global-scope suspend/resume changes that 
> might interfere?)

Some of them are in acpi.git and some have been merged already.

Thanks,
Rafael
