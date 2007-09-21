Return-Path: <linux-kernel-owner+w=401wt.eu-S1763075AbXIUW6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763075AbXIUW6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933576AbXIUWwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:52:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbXIUWwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:52:06 -0400
Date: Fri, 21 Sep 2007 18:52:03 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [20/45] x86_64: Use 8 byte stack alignment when
	possible
Message-ID: <20070921225203.GJ11455@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709211044.901175000@suse.de> <20070921204502.2C61D14EFF@wotan.suse.de> <20070921211341.GC8127@redhat.com> <200709220034.31227.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709220034.31227.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 12:34:31AM +0200, Andi Kleen wrote:
 > On Friday 21 September 2007 23:13, Dave Jones wrote:
 > > On Fri, Sep 21, 2007 at 10:45:02PM +0200, Andi Kleen wrote:
 > >  > Kernel doesn't use SSE2, so it doesn't need 16 byte alignment. Also
 > >  > the stack can be already unaligned so letting the compiler align
 > >  > is useless. This may make some stack frames smaller.
 > >  > Only works with very recent gcc 4.3
 > >
 > > My gcc 4.1.2 from Fedora 7 (with who knows what backported)
 > > references this in its manpage. How was it broken before 4.3 ?
 > 
 > Try it. It is rejected by the compiler in 64bit mode.

Ah yes, it fails if not between 4 & 12, but the call cc-option
catches that.  Looks fine to me.

	Dave

-- 
http://www.codemonkey.org.uk
