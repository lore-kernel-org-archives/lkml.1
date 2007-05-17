Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbXEQPC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbXEQPC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXEQPCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:02:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbXEQPCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:02:17 -0400
Date: Thu, 17 May 2007 11:02:05 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
Message-ID: <20070517150205.GA1453@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705171351.34531.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705171351.34531.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 01:51:34PM +0200, Andi Kleen wrote:

 > > The C3s all have cx8, but it needs to be enabled in an MSR first.
 > > (See arch/i386/kernel/cpu/centaur.c , search for CX8)
 > 
 > Sigh. I wonder what genius at VIA came up with that setup.

It was due to some incompatibility with some older Windows variants iirc.

 > > Did we add code that uses cmpxchg8b before identify_cpu() gets run ?
 > > I've not been paying attention to .22rc (busy trying to beat .21 into shape
 > > for F7) so I may have missed something obvious. Andi?
 > 
 > That would be a bit complicated in pure asm code. 
 > It's probably best to just not require it as in Christian's patch above.
 > Without SMP support it is not particularly needed anyways; a irq disabling
 > emulation should work.

*nod*

	Dave

-- 
http://www.codemonkey.org.uk
