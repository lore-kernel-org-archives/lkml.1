Return-Path: <linux-kernel-owner+w=401wt.eu-S1765780AbYEFQvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765780AbYEFQvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760562AbYEFQvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:51:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60841 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998AbYEFQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:51:14 -0400
Date: Tue, 6 May 2008 10:51:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506165112.GL19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <alpine.LFD.1.10.0805060931450.32269@woody.linux-foundation.org> <20080506164231.GK19219@parisc-linux.org> <20080506173948.6aed7475@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506173948.6aed7475@core>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 05:39:48PM +0100, Alan Cox wrote:
> > > Hmm?
> > 
> > So that find_conflict doesn't end up in the first column, which causes
> > diff to treat it as a function name for the purposes of the @@ lines.
> 
> Please can we just fix the tools not mangle the kernel to work around
> silly bugs ?

The people who control the tools refuse to fix them.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
