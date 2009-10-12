Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbZJLW3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbZJLW3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933481AbZJLW3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:29:53 -0400
Received: from thunk.org ([69.25.196.29]:50718 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975AbZJLW3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:29:52 -0400
Date: Mon, 12 Oct 2009 18:29:10 -0400
From: Theodore Tso <tytso@mit.edu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Weird ext4 bug: 256P used?
Message-ID: <20091012222910.GB18195@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 04:51:31PM +0300, Felipe Contreras wrote:
> This is what I get with 'du -x --max-depth=3 | sort -n'.
> 
> 140735340884184	./var/lib/yum
> 140735340910320	./usr/include
> 140735341711632	./var/lib
> 140735342038956	./var
> 140735344736432	./usr
> 281470691009304	.
> 
> I did 'touch /forcefsck', rebooted, and didn't get any error, so I
> guess at least the basic checks are passing.

So if you do "du -x | sort -n", what's the deepest directory that
shows a very large size, and can you find the files that seems to be
responsible for these large du reports?

					- Ted
