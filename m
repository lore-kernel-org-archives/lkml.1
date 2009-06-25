Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZFYUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZFYUmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZFYUmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:42:13 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33776 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZFYUmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:42:12 -0400
Date: Thu, 25 Jun 2009 22:44:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Bug in arch/x86/include/asm/boot.h [Was: next cleanup report: "bad" references to CONFIG variables]
Message-ID: <20090625204433.GA16384@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0906251028270.24694@localhost> <20090625192412.GA15823@uranus.ravnborg.org> <alpine.LFD.2.00.0906251521430.12376@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906251521430.12376@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 03:27:18PM -0400, Robert P. J. Day wrote:
> On Thu, 25 Jun 2009, Sam Ravnborg wrote:
> 
> > If you continue this then please filter the know false positives.
> > For once start ignoring defconfigs.
> 
>   just to be clear, yes, there are numerous output lines from
> defconfig files, but a simple entry in a defconfig file can never
> *contribute* to something being flagged as bad or unused.  all those
> lines represent is the subsequent global search once something *has*
> been flagged as unused or bad, just to show where it occurs anywhere
> in the tree (which is sometimes informative).
> 
>   if a variable occurred *only* in defconfig files, it would be
> ignored and nothing would be printed for it.  but if that defconfig
> output has no value, i can toss it.

It only indicates that the defconfig is old.
And this is irellevant for this - so toss it.

	Sam
