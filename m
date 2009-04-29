Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbZD2IFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbZD2IFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbZD2IF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:05:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50659 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZD2IF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:05:27 -0400
Date: Wed, 29 Apr 2009 10:04:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/13] x86, vmlinux.lds: unify header/footer
Message-ID: <20090429080455.GE22129@elte.hu>
References: <20090429073510.GA26386@uranus.ravnborg.org> <1240991249-27117-2-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240991249-27117-2-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> Merge everything except PHDRS and SECTIONS into
> vmlinux.lds.S
> No functional changes.
> 
> This include the removal of an ancient comment that
> Martin Mares wrote this file.

> -/* ld script to make i386 Linux 
> - * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>;

That's a historic copyright notice in essence which we should not 
remove - we should preserve that as:

> + Original 32-bit version written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>

(preferably with a date-of-that-original-patch inserted as well)

	Ingo
