Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZCQRjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZCQRjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 13:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbZCQRjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 13:39:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59516 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbZCQRjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 13:39:03 -0400
Date: Tue, 17 Mar 2009 11:38:45 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-pci@vger.kernel.org, Dexuan Cui <dexuan.cui@intel.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: Fix the definition of PCI_PM_CTRL_NO_SOFT_RESET
Message-ID: <20090317173845.GR14127@parisc-linux.org>
References: <49BFDB3C.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BFDB3C.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 04:17:48PM +0000, Jan Beulich wrote:
> From: Dexuan Cui <dexuan.cui@intel.com>
> 
> As per PCI Bus Power Management Interface Specification Revision 1.2
> this is bit 3, not bit 2, of the Power Management Control/Status
> register.

The same patch was already posted by Yu Zhao on February 25th and I
reviewed it for Jesse.  I don't see it in any of the trees yet though ...
(arguably, I should have picked it up for the fixes tree that I did
while Jesse was away).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
