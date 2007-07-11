Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbXGKQZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbXGKQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXGKQZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:25:18 -0400
Received: from THUNK.ORG ([69.25.196.29]:58289 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbXGKQZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:25:17 -0400
Date: Wed, 11 Jul 2007 12:25:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stefano Rivoir <s.rivoir@gts.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
Message-ID: <20070711162507.GC19456@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stefano Rivoir <s.rivoir@gts.it>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org> <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org> <46947ADF.4080605@gts.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46947ADF.4080605@gts.it>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 08:38:23AM +0200, Stefano Rivoir wrote:
> Probably it's something I had to know before... but the light lit when 
> gcc crashed when compiling 2.6.22-git1...

If gcc crashed when compiling 2.6.22-git1, and it didn't crash using
2.6.22, it would be really good idea to git bisect between 2.6.22 and
HEAD, to see what caused the gcc crash.

There may be two issues hiding here; whatever changeset caused the gcc
crash, and whatever change caused your 2.6.22 kernel to hang on boot;
they may not have the same root cause!

							- Ted
