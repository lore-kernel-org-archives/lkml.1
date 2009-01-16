Return-Path: <linux-kernel-owner+w=401wt.eu-S1765672AbZAPXEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765672AbZAPXEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZAPXEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:04:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51461 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbZAPXEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:04:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ACPI suspend: Fix compilation warnings in drivers/acpi/sleep.c
Date: Sat, 17 Jan 2009 00:03:51 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-tst; KDE/4.1.3; x86_64; ; )
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200901162309.14778.rjw@sisk.pl> <20090116144933.3ed476f9.akpm@linux-foundation.org>
In-Reply-To: <20090116144933.3ed476f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901170003.52015.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Andrew Morton wrote:
> On Fri, 16 Jan 2009 23:09:14 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Fix two compilation warnings in drivers/acpi/sleep.c, one triggered
> > by unsetting CONFIG_SUSPEND and the other triggered by unsetting
> > CONFIG_HIBERNATION, by moving some code under the appropriate
> > #ifdefs .
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  arch/x86/kernel/acpi/sleep.c |    4 +--
> >  drivers/acpi/sleep.c         |   51 +++++++++++++++++++++----------------------
> 
> Confused.  drivers/acpi/sleep.c was removed six years ago?

It's back in 2.6.29-rc2. :-)
