Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbXEQGSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbXEQGSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXEQGSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:18:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbXEQGSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:18:06 -0400
Date: Thu, 17 May 2007 02:17:08 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christian <haveaniceday@cv-sv.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
Message-ID: <20070517061708.GL30166@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Christian <haveaniceday@cv-sv.de>,
	linux-kernel@vger.kernel.org
References: <464B9D2C.7040704@cv-sv.de> <alpine.LFD.0.98.0705161750350.3890@woody.linux-foundation.org> <464BAF07.9020003@cv-sv.de> <alpine.LFD.0.98.0705161920410.3890@woody.linux-foundation.org> <464BC67F.7080707@zytor.com> <alpine.LFD.0.98.0705162012340.3890@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705162012340.3890@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 08:16:11PM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Wed, 16 May 2007, H. Peter Anvin wrote:
 > > 
 > > It gets turned on by the code in arch/i386/kernel/cpu.  It's just that
 > > the new code that Andi added runs during setup, i.e. in real mode, so
 > > *way* earlier than that.
 > 
 > Ahh. Do we really need it that early?
 > 
 > Now, it's easy enough to just turn off CONFIG_X86_CMPXCHG64 (it really 
 > should be "8B" instead of "64", but that's another issue) for those 
 > things, and nobody should really care, but still, maybe we could re-do the 
 > early bits to be more polite to those VIA CPU's?
 > 
 > I thought the cmpxchg8b stuff was just used to page table setup. Do those 
 > things even _support_ PAE?

newer models do, yes. Even NX.  In fact, primarily for NX. I've not heard
of anyone running >4GB with a Nehemiah.

	Dave

-- 
http://www.codemonkey.org.uk
