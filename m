Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYJIVgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYJIVgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757519AbYJIVfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:35:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43666 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbYJIVfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:35:52 -0400
Date: Thu, 9 Oct 2008 15:35:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
Message-ID: <20081009213551.GC25780@parisc-linux.org>
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org> <48EE7745.2020603@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EE7745.2020603@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 02:27:33PM -0700, Yinghai Lu wrote:
> >> aacraid 0000:86:00.0: using 32bit DMA mask
> >> aacraid 0000:86:00.0: using 32bit consistent DMA mask
> >> aacraid 0000:86:00.0: using 64bit DMA mask
> >> aacraid 0000:86:00.0: using 64bit consistent DMA mask
> 
> and aacraid do 32bit at first then 64bit...
> 
> so put that in boot message could be useful too.

Why's that interesting to the sysadmin of the machine?  To the driver
writer, certainly.  But what's the use of it to the people using the
machine?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
