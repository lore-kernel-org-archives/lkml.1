Return-Path: <linux-kernel-owner+w=401wt.eu-S1765466AbXJRWqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765466AbXJRWqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXJRWpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:45:53 -0400
Received: from mail.suse.de ([195.135.220.2]:59024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbXJRWpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:45:52 -0400
Date: Fri, 19 Oct 2007 00:45:51 +0200
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, ak@suse.de, bwalle@suse.de,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       vgoyal@in.ibm.com
Subject: Re: [patch 1/3] Add BSS to resource tree
Message-ID: <20071018224550.GD3459@bingen.suse.de>
References: <20071018111535.356215664@strauss.suse.de> <20071018111535.883533731@strauss.suse.de> <20071018142642.5b3f6ba4.akpm@linux-foundation.org> <20071018214836.GA3459@bingen.suse.de> <20071018215827.GB23708@uranus.ravnborg.org> <20071018220048.GB3459@bingen.suse.de> <20071018221813.GA23801@uranus.ravnborg.org> <20071018153751.c9c458c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018153751.c9c458c8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 03:37:51PM -0700, Andrew Morton wrote:
> On Fri, 19 Oct 2007 00:18:13 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > And I recall that extern char sym[] is considered correct by binutils 
> > people - but I'm not 100% sure and google did not give me an appropriate hit.
> 
> An ancient memory tells me that these things are traditionally
> declared as plain old int:
> 
> extern int start;
> extern int edata;

int is probably one of the less useful types. Typical operation is computing
the difference between two symbols in bytes. &int without cast would give
you a useless scaled size.

-Andi

