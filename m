Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXBNTjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXBNTjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXBNTjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:39:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:44819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXBNTjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:39:45 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix d_path for lazy unmounts
Date: Wed, 14 Feb 2007 11:39:40 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       walt <wa1ter@myrealbox.com>
References: <200702021923.02491.agruen@suse.de> <200702140019.36378.agruen@suse.de> <Pine.LNX.4.64.0702140730350.3604@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702140730350.3604@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141139.41465.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 07:37, Linus Torvalds wrote:
> We could prepend another '/' (so that you'd have a path that starts with
> "//"). That's still a legal path, but it's also somethign that even POSIX
> says is valid to mean something else (eg "//ftp/.." or "//socket/.." to
> escape into another namespace).

This sounds good enough to me. My main point is that users that care should be 
able to tell the difference.

Thanks,
Andreas
