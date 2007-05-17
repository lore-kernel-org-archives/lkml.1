Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbXEQVts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbXEQVts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbXEQVtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:49:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbXEQVtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:49:40 -0400
Date: Thu, 17 May 2007 17:47:54 -0400
From: Dave Jones <davej@redhat.com>
To: Christian Volkmann <haveaniceday@cv-sv.de>
Cc: linux-kernel@vger.kernel.org, ak@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
Message-ID: <20070517214754.GC398@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christian Volkmann <haveaniceday@cv-sv.de>,
	linux-kernel@vger.kernel.org, ak@suse.de,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <464BB252.8010008@cv-sv.de> <464CC8E1.5010407@cv-sv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464CC8E1.5010407@cv-sv.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 11:28:01PM +0200, Christian Volkmann wrote:

 > - Important: somebody to check other CPU types if the same behavior happens.

arch/i386/kernel/cpu/rise.c

Though, I've *never* seen or even heard of someone with one of those CPUs,
so whether we need to care is questionable. The mp6 did actually make it
to manufacture aparently, but I don't think anyone actually bought one.
http://en.wikipedia.org/wiki/Rise_Technology for a pic of this mythical beast.

	Dave

-- 
http://www.codemonkey.org.uk
