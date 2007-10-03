Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbXJCQnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbXJCQnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 12:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXJCQnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 12:43:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33267 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXJCQnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 12:43:14 -0400
Date: Wed, 3 Oct 2007 10:43:13 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: [Question] How to represent SYSTEM_RAM in kerenel/resouce.c
Message-ID: <20071003164313.GH12049@parisc-linux.org>
References: <20071003103136.addbe839.kamezawa.hiroyu@jp.fujitsu.com> <1191429433.4939.49.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191429433.4939.49.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 09:37:13AM -0700, Dave Hansen wrote:
> I think we should take system ram out of the iomem file, at least.

Rubbish.  iomem is a representation of the physical addresses in the
system as seen from the CPU's perspective.  As I said in my previous
mail in this thread, if you attempt to map a device's BAR over the top
of physical RAM, things will go poorly for you.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
