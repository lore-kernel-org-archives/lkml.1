Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbXG0AMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbXG0AMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXG0ALy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:11:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbXG0ALx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:11:53 -0400
From: Neil Brown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Date: Fri, 27 Jul 2007 10:11:41 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18089.14397.946323.617318@notabene.brown>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockd and nfsd endianness annotation fixes
In-Reply-To: message from J. Bruce Fields on Thursday July 26
References: <E1IE6Hd-0005Dl-Hu@ZenIV.linux.org.uk>
	<20070726220853.GN8125@fieldses.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday July 26, bfields@fieldses.org wrote:
> On Thu, Jul 26, 2007 at 05:33:49PM +0100, Al Viro wrote:
> > 
> 
> Oops, thanks; these are my fault.
> 
> (How are you finding these?  I was assuming sparse, but running a make
> -C2 just now I didn't see anything that would have suggested these
> fixes.  I'm using whatever's current in Fedora--it says 0.3-1.fc7.  Do I
> need something more recent?)

I have a note about that somewhere.....

> From: Al Viro <viro@ftp.linux.org.uk>
> Subject: Re: [PATCHSET] nfs endianness annotations
> Date: Thu, 19 Oct 2006 02:26:00 +0100
> ....
> 
> Folks, seriously, please run sparse after changes; it's a simple matter of
> make C=2 CF=-D__CHECK_ENDIAN__ fs/nfs*/; nothing tricky and it saves a lot
> of potential PITA...

And with lots of good intentions, I ran this about once, and promptly
forgot.
Apologies.

NeilBrown
