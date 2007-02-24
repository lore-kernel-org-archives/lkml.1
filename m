Return-Path: <linux-kernel-owner+w=401wt.eu-S933540AbXBXUIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540AbXBXUIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 15:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933552AbXBXUIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 15:08:17 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:59946 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933540AbXBXUIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 15:08:17 -0500
Date: Sat, 24 Feb 2007 21:07:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Detecting section mismatches in vmlinux
Message-ID: <20070224200756.GA9417@uranus.ravnborg.org>
References: <20070222.005728.126762028.anemo@mba.ocn.ne.jp> <20070225.035315.25909736.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225.035315.25909736.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 03:53:15AM +0900, Atsushi Nemoto wrote:
> 
> This is a dirty hack to check all built-in.o just after linking
> vmlinux.  But this can not detect mismatches in libs.a files, and
> modpost fails with "... is truncated" message on empty built-in.o
> files.
> 
> Maybe checking at each $(LD) invocation should detect all mismatches,
> but I'm not familer with kbuild to do it by myself.  Could someone
> make perfect solution?

I would prefer to find out why it fails when running the check
on full vmlinux.
Your suggestion is like papering over the real bug - and only
if something prevent us from detecting this in full
vmlinux should we do it for each LD invocation.

	Sam
