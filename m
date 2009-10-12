Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbZJLOsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbZJLOsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932349AbZJLOsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:48:36 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38940 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347AbZJLOsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:48:35 -0400
Date: Mon, 12 Oct 2009 10:47:41 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Greg Ungerer <gerg@snapgear.com>
cc: Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 2/2] m68knommu: Clean up linker script using new linker
 script macros.
In-Reply-To: <4AC44477.8000703@snapgear.com>
Message-ID: <alpine.DEB.1.10.0910010905340.5982@dr-wily.mit.edu>
References: <1253638615-27009-1-git-send-email-tabbott@ksplice.com> <1253638615-27009-3-git-send-email-tabbott@ksplice.com> <4AC44477.8000703@snapgear.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Greg Ungerer wrote:

> Hi Tim,
> 
> Tim Abbott wrote:
> > Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> > Cc: Greg Ungerer <gerg@uclinux.org>
> 
> This results in kernels that don't boot for me. I haven't done
> any more debugging than to just try booting at this time.
[...]
> 
> Does that look like what you would have expected?

Basically.  I'm a bit surprised that the .init_begin section doesn't show 
up, but I'm pretty sure that this is because .init_begin would have had 
size zero as the previous section's end was already page-aligned.

> I suspect the problem may lie in the binary conversion of this
> elf file to a raw binary for booting. This uses objcopy with
> "-O binary". The resulting binary files are different in size
> with and without the patch by about 2582 bytes. Suspicious
> me thinks.

I don't any good ideas for what in patch is likely to be responsible.  
Would it be helpful to debug if I split this into ~5 very small patches so 
that we can find out what part of the patch is responsible?

	-Tim Abbott
