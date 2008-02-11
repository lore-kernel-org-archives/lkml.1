Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYBKXgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYBKXgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYBKXgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:36:00 -0500
Received: from waste.org ([66.93.16.53]:38364 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbYBKXf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:35:59 -0500
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for
	some	processors
From: Matt Mackall <mpm@selenic.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com
In-Reply-To: <47B0D3B7.6070308@zytor.com>
References: <200802082347.25364.michael-lists@free-electrons.com>
	 <20080208231130.GA10511@elte.hu>
	 <200802112342.23493.michael-lists@free-electrons.com>
	 <1202770566.12383.59.camel@cinder.waste.org>  <47B0D3B7.6070308@zytor.com>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 17:28:52 -0600
Message-Id: <1202772532.12383.67.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 15:01 -0800, H. Peter Anvin wrote:
> Matt Mackall wrote:
> > 
> > Best would be to have no ifdefs and do it all with linker magic, of
> > course. But that's trickier.
> > 
> 
> I concur with this, definitely.

Ok, so let's come up with a plan. We can:

a) use weak symbols, ala cond_syscall
b) use a special section
c) use early_init code (is it early enough?)
c) have some sort of registration list

Having a generic cond_call of some sort might be nice for this sort of
thing.

-- 
Mathematics is the supreme nostalgia of our time.

