Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbZFYT33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbZFYT33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZFYT3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:29:21 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:58814 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZFYT3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:29:20 -0400
Date: Thu, 25 Jun 2009 15:27:18 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Bug in arch/x86/include/asm/boot.h [Was: next cleanup report: 
 "bad" references to CONFIG variables]
In-Reply-To: <20090625192412.GA15823@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0906251521430.12376@localhost>
References: <alpine.LFD.2.00.0906251028270.24694@localhost> <20090625192412.GA15823@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Sam Ravnborg wrote:

> If you continue this then please filter the know false positives.
> For once start ignoring defconfigs.

  just to be clear, yes, there are numerous output lines from
defconfig files, but a simple entry in a defconfig file can never
*contribute* to something being flagged as bad or unused.  all those
lines represent is the subsequent global search once something *has*
been flagged as unused or bad, just to show where it occurs anywhere
in the tree (which is sometimes informative).

  if a variable occurred *only* in defconfig files, it would be
ignored and nothing would be printed for it.  but if that defconfig
output has no value, i can toss it.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
