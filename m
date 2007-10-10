Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbXJJLqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbXJJLqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 07:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbXJJLpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 07:45:54 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:58848 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXJJLpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 07:45:53 -0400
Message-ID: <470CBB6A.7020305@freedesktop.org>
Date: Wed, 10 Oct 2007 04:45:46 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       davej@codemonkey.org.uk, Pierre Ossman <drzeus@drzeus.cx>,
       akpm@osdl.org, linux-sparse@vger.kernel.org
Subject: Re: idio{,ma}tic typos (was Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch
 added to -mm tree)
References: <20071010104540.GA6366@localhost.sw.ru>
In-Reply-To: <20071010104540.GA6366@localhost.sw.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> ["if (!x & y)" patch from yanzheng@]
> ["if (!x & y)" patch from adobriyan@]
> ["if (!x & y)" patches from viro@]
> 
> While we're at it, below is somewhat ugly sparse patch for detecting
> "&& 0x" typos.

Excellent idea!  I think it applies to || as well.  I'll most likely
add a -Wboolean-logic-on-bit-constant to turn this warning on.

Any reason why this wouldn't apply to octal constants or to GCC's new
binary constants?  I can trivially modify this patch to handle those
as well, just by dropping the check for an 'x' or 'X', and renaming the
flag.

As far as patch beauty goes, I think this patch looks just fine.

- Josh Triplett

