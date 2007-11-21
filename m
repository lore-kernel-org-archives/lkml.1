Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbXKUUmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbXKUUmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbXKUUl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:41:57 -0500
Received: from www.tglx.de ([62.245.132.106]:36133 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbXKUUl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:41:56 -0500
Date: Wed, 21 Nov 2007 21:41:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Don Zickus <dzickus@redhat.com>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [PATCH] Add the word 'Warning' in check_nmi_watchdog() output
In-Reply-To: <20071121184403.GD12071@redhat.com>
Message-ID: <alpine.LFD.0.9999.0711212137380.25057@localhost.localdomain>
References: <1195665260-14641-1-git-send-email-dzickus@redhat.com> <20071121103459.0b9b0302@laptopd505.fenrus.org> <20071121184403.GD12071@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Don Zickus wrote:

> On Wed, Nov 21, 2007 at 10:34:59AM -0800, Arjan van de Ven wrote:
> > On Wed, 21 Nov 2007 12:14:20 -0500
> > Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > Our automated test suite looks for keywords like error, fail, warning
> > > in the boot log.  In the case when the nmi watchdog is determined to
> > > be stuck in check_nmi_watchdog(), none of those keywords are
> > > displayed.
> > 
> > 
> > please make it at least consistent with the other kernel level bad
> > things, and use "WARNING:"....
> 
> Good point.  I'll repost.

Before you repost, please add an appropriate KERN_WARN prefix to the
printk and run your patch through scripts/checkpatch.pl.

	tglx
