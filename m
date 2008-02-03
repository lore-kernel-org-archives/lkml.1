Return-Path: <linux-kernel-owner+w=401wt.eu-S933681AbYBCLwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681AbYBCLwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762813AbYBCLwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:52:40 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:53812 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763278AbYBCLwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:52:39 -0500
Date: Sun, 3 Feb 2008 12:52:34 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kprobes: Introduce kprobe_handle_fault()
Message-ID: <20080203115234.GC18211@osiris.ibm.com>
References: <1202007623.1844.44.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202007623.1844.44.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 07:00:23PM -0800, Harvey Harrison wrote:
> Use a central kprobe_handle_fault() inline in kprobes.h to remove
> all of the arch-dependant, practically identical implementations in
> avr32, ia64, powerpc, s390, sparc64, and x86.
> 
> avr32 was the only arch without the preempt_disable/enable pair
> in its notify_page_fault implementation.
> 
> This uncovered a possible bug in the s390 version as that purely
> copied the x86 version unconditionally passing 14 as the trapnr
> rather than the error_code parameter.  s390 is changed to pass
> error_code in this patch.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

for the s390 bits:

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
