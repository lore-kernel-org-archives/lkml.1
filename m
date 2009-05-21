Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZEUUJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZEUUJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZEUUJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:09:42 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42206 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZEUUJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:09:41 -0400
Date: Thu, 21 May 2009 14:09:42 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/5] Dump the inode structure (for debugging purposes
	only)
Message-ID: <20090521200942.GA5110@parisc-linux.org>
References: <1242936063-31689-1-git-send-email-tytso@mit.edu> <1242936063-31689-2-git-send-email-tytso@mit.edu> <1242936063-31689-3-git-send-email-tytso@mit.edu> <1242936063-31689-4-git-send-email-tytso@mit.edu> <1242936063-31689-5-git-send-email-tytso@mit.edu> <1242936063-31689-6-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242936063-31689-6-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 04:01:03PM -0400, Theodore Ts'o wrote:
> This is not intended for merging; but it's useful for determining how
> much varous fields in the struct inode space, and whether there is any
> padding leading to waste, especially on a 64-bit platforms.

Why not just use acme's pahole?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
