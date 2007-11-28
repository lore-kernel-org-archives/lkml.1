Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbXK1XOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbXK1XOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbXK1XOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:14:23 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:39094 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbXK1XOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:14:22 -0500
Date: Wed, 28 Nov 2007 16:14:21 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm2: Result: hostbyte=0x01 driverbyte=0x00\nend_request: I/O error
Message-ID: <20071128231421.GB2584@parisc-linux.org>
References: <20071128034140.648383f0.akpm@linux-foundation.org> <20071128200130.GA13361@martell.zuzino.mipt.ru> <20071128134036.417b3def.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128134036.417b3def.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 01:40:36PM -0800, Andrew Morton wrote:
> On Wed, 28 Nov 2007 23:01:31 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > Reliably spams dmesg with end_request() horrors. This happens when git
> > starts checking out linux tree to fresh ext2 partition. Disk is several
> > month old and there were no prolems with, say, 2.6.24-rc3:

Could you try reverting 6f5391c283d7fdcf24bf40786ea79061919d1e1d and see
if the problem still exists?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
