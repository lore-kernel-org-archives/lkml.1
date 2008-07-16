Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbYGPOlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbYGPOlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbYGPOlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:41:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42863 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbYGPOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:41:08 -0400
Date: Wed, 16 Jul 2008 08:41:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Message-ID: <20080716144106.GD25255@parisc-linux.org>
References: <1216138543.3312.60.camel@localhost.localdomain> <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu> <20080716131543.GA3673@elte.hu> <1216216320.3230.1.camel@localhost.localdomain> <20080716141805.GB22631@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716141805.GB22631@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 04:18:05PM +0200, Ingo Molnar wrote:
> btw., about the technical aspects of the solution, i'm not sure i like 
> these big #ifdef blocks:

It's partly the nature of the beast.  There's already several large
#ifdef blocks in compat_ioctl.c -- CONFIG_NET, CONFIG_VT, CONFIG_SPARC,
etc.  I think what would help is a bit more grouping so individual
blocks get bigger.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
