Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYGVTyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYGVTyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbYGVTxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:53:50 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49550 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbYGVTxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:53:49 -0400
Date: Tue, 22 Jul 2008 13:53:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Julia Lawall <julia@diku.dk>
Cc: avi@qumranet.com, kvm@vger.kernel.org, xiantao.zhang@intel.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH retry] arch/ia64/kvm/kvm-ia64.c: Add local_irq_restore in error handling code
Message-ID: <20080722195329.GG7337@parisc-linux.org>
References: <Pine.LNX.4.64.0807222137350.2670@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807222137350.2670@ask.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 09:38:18PM +0200, Julia Lawall wrote:
> There is a call to local_irq_restore in the normal exit case, so it would
> seem that there should be one on an error return as well.

Patch looks good to me:

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
