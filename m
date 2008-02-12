Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbYBLR27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbYBLR27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbYBLR2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:28:51 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48719 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbYBLR2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:28:50 -0500
Date: Tue, 12 Feb 2008 11:28:49 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: clg@fr.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xemul@openvz.org,
       serue@us.ibm.com
Subject: Re: [patch 0/3] clone64() and unshare64() syscalls
Message-ID: <20080212172849.GB12177@sergelap.austin.ibm.com>
References: <20080211095806.585883882@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211095806.585883882@fr.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting clg@fr.ibm.com (clg@fr.ibm.com):
> yet another try to extend the clone flags and probably not the last !
> 
> This patchset adds 2 new syscalls :
> 
>      long sys_clone64(unsigned long flags_high, unsigned long flags_low,
> 		unsigned long newsp);
> 
>      long sys_unshare64(unsigned long flags_high, unsigned long flags_low);
> 
> The current version of clone64() does not support CLONE_PARENT_SETTID and 
> CLONE_CHILD_CLEARTID because we would exceed the 6 registers limit of some 
> arches. It's possible to get around this limitation but we might not
> need it as we already have clone()
> 
> This is work in progress but already includes support for x86, x86_64, 
> x86_64(32), ppc64, ppc64(32), s390x, s390x(31). 
> 
> ia64 already supports 64bits clone flags through the clone2() syscall.
> should we harmonize the name to clone2 ?  
> 
> 
> Please see the changelog below.

Tested unshare64 with a new namespace using the first clone_hi bit, no
problems here (on a kvm-qemu image).

-serge
