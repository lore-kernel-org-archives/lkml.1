Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbXLKUlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbXLKUlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbXLKUla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:41:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753131AbXLKUl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:41:29 -0500
Date: Tue, 11 Dec 2007 12:40:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, pavel@ucw.cz, rjw@sisk.pl
Subject: Re: +
 revert-hibernation-enter-platform-hibernation-state-in-a-consistent-way.patch
 added to -mm tree
Message-Id: <20071211124049.44a15ff3.akpm@linux-foundation.org>
In-Reply-To: <200712111501.13754.maximlevitsky@gmail.com>
References: <200712110958.lBB9wDJl012816@imap1.linux-foundation.org>
	<200712111501.13754.maximlevitsky@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 15:01:13 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Tuesday 11 December 2007 11:58:09 akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      revert "Hibernation: Enter platform hibernation state in a consistent way"
> > has been added to the -mm tree.  Its filename is
> >      revert-hibernation-enter-platform-hibernation-state-in-a-consistent-way.patch
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > ------------------------------------------------------
> > Subject: revert "Hibernation: Enter platform hibernation state in a consistent way"
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Revert
> > 
> >     commit 9cd9a0058dd35268b24fa16795a92c800f4086d4
> >     Author: Rafael J. Wysocki <rjw@sisk.pl>
> >     Date:   Thu Oct 18 03:04:56 2007 -0700
> > 
> >         Hibernation: Enter platform hibernation state in a consistent way
> > 
> > Because it causes my t61p's suspend-to-RAM to immediately do a
> > resume-from-RAM.
> Noooo....
> 
> First of all, this commit doesn't touch the S3, so you probably
> mean S4.

Nope, I meant suspend-to-RAM.  The t61p was auto-resuming during
suspend-to-RAM.  However I just went in to confirm the fix and the bug (a
regression) has just gone away altogether(!).   I'll keep an eye on it.


