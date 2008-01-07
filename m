Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYAGQek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYAGQek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbYAGQed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:34:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37253 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253AbYAGQec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:34:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Rename suspend/hibernation stuff for clarity
Date: Mon, 7 Jan 2008 17:36:39 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>
References: <20080107135236.GA17140@elf.ucw.cz>
In-Reply-To: <20080107135236.GA17140@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071736.39782.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of January 2008, Pavel Machek wrote:
> kernel/suspend_64.c and power/cpu.c were equivalent. Move them into
> power/cpu_*.c for consistency.
> 
> power/swsusp.S and kernel/suspend_asm_64.S were both misnamed and
> equivalent. Merge then minto power/hibernation_*.S.

Well, all of that are changes in the right direction, but I'm not sure if it's
the right time to do that just now.  For example, suspend_64.c in your patch
is missing the comments on __save/restore_processor_state() already queued
up for 2.6.25 by Ingo.

Any chance to base the patch on top of the mm branch of
/pub/scm / linux/kernel/git/x86/linux-2.6-x86.git ?

Thanks,
Rafael
