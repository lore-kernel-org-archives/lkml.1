Return-Path: <linux-kernel-owner+w=401wt.eu-S1751403AbZL0H4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbZL0H4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 02:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZL0H4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 02:56:52 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52586 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZL0H4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 02:56:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q1ifXwnMkWNibE2kvzVlXNCs7ne0l8+ZZyRai2Lim+jbNV2SOrrr+cLmmurolXyJLZ
         ZHZZWuNF2i1nDZjJgR/wSPygHHFrUSHPASdJqnsuJB8fN4wdCCXwKLmCM1GBtmaIcnBA
         dlMlzIXy9AncjmGiEzU5PbWm7cUHlin53Ub50=
Date: Sat, 26 Dec 2009 23:56:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: tytso@mit.edu
Cc: Philip Wernersbach <philip.wernersbach@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2/3 as ext4
Message-ID: <20091227075647.GA3223@core.coreip.homeip.net>
References: <1daf33050912011730l5def95brac3ce60647bc2040@mail.gmail.com>
 <20091207190947.GF27692@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207190947.GF27692@thunk.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Mon, Dec 07, 2009 at 02:09:47PM -0500, tytso@mit.edu wrote:
> On Tue, Dec 01, 2009 at 08:30:36PM -0500, Philip Wernersbach wrote:
> > Hello Everyone,
> >      Below is a small patch I wrote for kernel version 2.6.31.6. It
> > causes ext2/3 filesystems to be mounted using the ext4 driver, in a
> > way that is transparent to the userspace (and kernelspace for that
> > matter, as long as the code uses the kernel's mounting API) and
> > requires no change to the userspace (/kernelspace). This patch is
> > useful because: 1) It allows minimalist kernel fanatics, like myself,
> > to drop 2 drivers from their builds without any loss in functionality.
> > 2) It allows the ext2/3 filesystems to take advantage of the
> > performance/general improvements in the ext4 driver. 3) In the future,
> > with this patch, the ext2/3 driver code could be dropped from the
> > kernel without any loss in functionality.
> 
> Here's a much cleaner patch which achieves the same goal...
> 

I experience regular crashes with 2.6.32-rc2 that seem to be related to
this patch as thet seem to go away if I enable proper ext3 support.

Kernel BUG()s out in ext4_da_update_reserve_space(); unofrtunately
traces don't make it ot the disk but I managed to snatch a picture with
my didgital camera:

	http://userweb.kernel.org/~dtor/ext4-oops.jpg

I also tried pulling your latest pull request for Linus but the behavior
is the same.

Thanks.

-- 
Dmitry
