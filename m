Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0BSVC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:02:26 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:37814 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab0BSVCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:02:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oQZKn3nanm2FtExcQ6eQxrtAjdSQ/d5wKdihOSPFSx4jjItN/as3Lfj0Oja40dbhr/
         LSTXbO1QnXYrNuAcN2ewPxIv6xjjuXUkicTqtIzCf3PrKcAe4Em/FMuRrB0Udnxk10XH
         gZKvQfRinS1Xp511qcs9REEa9K3/eGlLr0tfE=
MIME-Version: 1.0
In-Reply-To: <m3d403632g.fsf@lugabout.jhcloos.org>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	 <20100215154516.GB11057@think> <m3d403632g.fsf@lugabout.jhcloos.org>
Date: Sat, 20 Feb 2010 07:02:23 +1000
Message-ID: <21d7e9971002191302s76111f6fyd986c51b66e214ae@mail.gmail.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
From: Dave Airlie <airlied@gmail.com>
To: James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 6:04 AM, James Cloos <cloos@jhcloos.com> wrote:
> While getting re-aquainted with perf, and after upgrading to the current
> version, I see that do_page_fault, unmap_vmas, get_page_from_freelist,
> handle_mm_fault, __do_fault and T.1339 tend to get the most time when the
> kernel is spinning.

dmesg? lspci -vv?

We have an AGP related issue with WC/UC paging that might be related,
but I'd need more info.

Dave.
