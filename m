Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbXF3FP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbXF3FP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 01:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXF3FPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 01:15:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572AbXF3FPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 01:15:19 -0400
Date: Fri, 29 Jun 2007 22:15:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
Message-Id: <20070629221510.95c4c8e1.akpm@linux-foundation.org>
In-Reply-To: <15437.1183177066@turing-police.cc.vt.edu>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<6150.1183128630@turing-police.cc.vt.edu>
	<20070629140130.59d58c44.akpm@linux-foundation.org>
	<15437.1183177066@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007 00:17:46 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Fri, 29 Jun 2007 14:01:30 PDT, Andrew Morton said:
> > On Fri, 29 Jun 2007 10:50:30 -0400
> > Valdis.Kletnieks@vt.edu wrote:
> 
> > > Odd - just for grins, I checked what 'make oldconfig' did when handed a .config
> > > from 22-rc4-mm2, and it behaved just fine, much to my surprise.
> > 
> > That's probably because your old config file was relatively recent, and
> > had things like CONFIG_BLK_DEV=y in it.
> 
> Ahh... <light bulb goes on> Yeah, it gets a 'make oldconfig' for pretty
> much every single -mm, I suck at any regression testing other than "since
> the last -mm".
> 

All my .configs have mouldered since I lost the ability to have .config be
a symlink to a revision-controlled file (used to carry a custom patch for
this, but it died).

I continue to believe that kbuild's lets-trash-your-symlink behaviour is
obnoxious, but I was unable to persuade anyone else of this.

