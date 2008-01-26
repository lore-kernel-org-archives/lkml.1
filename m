Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYAZXjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYAZXjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 18:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYAZXj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 18:39:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55552 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbYAZXjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 18:39:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Q: x86 suspend/hibernation code consolidation
Date: Sun, 27 Jan 2008 00:36:39 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200801260132.09529.rjw@sisk.pl> <20080126094239.GA4096@ucw.cz>
In-Reply-To: <20080126094239.GA4096@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801270036.41249.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 26 of January 2008, Pavel Machek wrote:
> Hi!
> 
> > I'd like to move the 64-bit suspend/hibernation files from arch/x86/kernel to
> > arch/x86/power, modify the names of the 32-bit files already in
> > arch/x86/power and update the Makefiles accordingly, but there are some changes
> > queued for merging that touch the files in question.
> 
> I have similar patch producing hibernation_*.S, I can send it as a
> base.

Well, it probably will have to be rebased anyway.  That's the problem: what to
base it on to avoid conflicts.

> Moving it soon  would be nice :-).

Yes, but I'm afraid not earlier than after the ACPI suspend tree is merged.

> As I'm in process of rewriting arch/x86/kernel/acpi/ , I'd prefer that
> not to be moved from under me.

I'm not going to touch that now. :-)

Greetings,
Rafael
