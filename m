Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbXDHSqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbXDHSqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXDHSqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:46:23 -0400
Received: from lazybastard.de ([212.112.238.170]:60964 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbXDHSqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:46:22 -0400
Date: Sun, 8 Apr 2007 20:41:30 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
Message-ID: <20070408184129.GA20871@lazybastard.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46193048.6000606@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 April 2007 11:11:20 -0700, H. Peter Anvin wrote:
> 
> Well, the question is if you can keep the seekdir/telldir cookie around 
> as a pointer -- preferrably in userspace, of course.  You would 
> presumably garbage-collect them on closedir() -- there is no other point 
> at which you could.

Garbage-collecting them on closedir() does not work.  It surprised me as
well, but there seem to be applications that keep the telldir() cookie
around after closedir().  Iirc, "rm -r" was one of them.

Neil, is this correct?

Jörn

-- 
Data dominates. If you've chosen the right data structures and organized
things well, the algorithms will almost always be self-evident. Data
structures, not algorithms, are central to programming.
-- Rob Pike
