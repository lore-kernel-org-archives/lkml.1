Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbZDUVNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbZDUVNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZDUVM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:12:56 -0400
Received: from sous-sol.org ([216.99.217.87]:56572 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757778AbZDUVM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:12:56 -0400
Date: Tue, 21 Apr 2009 14:10:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Pavel Roskin <proski@gnu.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org, schwab@linux-m68k.org,
       krzysztof.h1@poczta.fm
Subject: Re: [stable] [BISECTED] x11 fbdev on intelfb hangs hard after
	66c1ca019078220dc1bf968f2bb18421100ef147
Message-ID: <20090421211035.GC3036@sequoia.sous-sol.org>
References: <1239314524.7390.14.camel@mj> <20090410081428.GA5595@linux> <20090421183424.GE22386@hera.kernel.org> <20090421205949.GB5573@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421205949.GB5573@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi (righi.andrea@gmail.com) wrote:
> On Tue, Apr 21, 2009 at 06:34:24PM +0000, Chris Wright wrote:
> > * Andrea Righi (righi.andrea@gmail.com) wrote:
> > > Thanks for reporting Pavel. I agree to revert 66c1ca ASAP.
> > 
> > Rather than dropping from -stable queue, looks like we should be adding:
> > 513adb58685615b0b1d47a3f0d40f5352beff189 "fbdev: fix info->lock deadlock
> > in fbcon_event_notify()"? 
> 
> Correct.
> 
> Both Andreas and Krzysztof (in cc) tested this and reported that it
> fixes the issue (see also http://patchwork.kernel.org/patch/17753/).

queued. thanks,
-chris
