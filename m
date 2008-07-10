Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbYGJBfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbYGJBfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYGJBfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:35:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52254 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbYGJBfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:35:22 -0400
Date: Wed, 9 Jul 2008 19:35:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] PCI MSI: Store the number of messages in the msi_desc
Message-ID: <20080710013520.GM14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-1-git-send-email-matthew@wil.cx> <1215396324.19157.14.camel@localhost> <20080707024125.GU14894@parisc-linux.org> <1215402512.9862.16.camel@localhost> <20080707120418.GZ14894@parisc-linux.org> <1215653563.13950.39.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215653563.13950.39.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 11:32:43AM +1000, Michael Ellerman wrote:
> That is cleaner, you get to fix it when they create MSIXX though ;)

Heh, I've been calling it MSI-Y in my internal monologue ;-)  Maybe
it'll be MSIe though.

> Perhaps I'm pedantic, but I'd rather it was two patches, one to change
> type to is_msix and one to add the multiple flag.

I'll make that change.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
