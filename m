Return-Path: <linux-kernel-owner+w=401wt.eu-S965992AbXDGXp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965992AbXDGXp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 19:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965994AbXDGXp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 19:45:29 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:40130 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965992AbXDGXp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 19:45:28 -0400
Date: Sun, 8 Apr 2007 01:44:34 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Theodore Tso <tytso@mit.edu>
cc: Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: <20070407203633.GA21555@thunk.org>
Message-ID: <Pine.LNX.4.61.0704080142080.27251@yvahk01.tjqt.qr>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
 <20070407203633.GA21555@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 7 2007 16:36, Theodore Tso wrote:
>
>So how do we solve this problem?  I can think of two solutions:
>
>1) Deprecate telldir/seekdir() altogether.  Relatively few progams use
>this functionality, and it is highly questionable how useful it is,
>anyway.  If you use telldir/seekdir and keep the cookie for a long
>time, even the POSIX-provided guarantees about files that are created
>and deleted between the telldir() and seekdir() points in time makes
>its utility highly dubious.
>
>2) If application programs must have telldir/seekdir, than expand the
>size of the cookie from 32-bits to a minimum of 128 bits, and
>preferably larger --- say 512 bits, to accomodate systems that might
>be using 512-bit variant of SHA-2.  [...]

Maybe a combination of both? That is, replace telldir by an
independent emulation layer.


Jan
-- 
