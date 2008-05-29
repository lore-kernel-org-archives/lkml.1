Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYE2Urr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYE2Urr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYE2Uri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:47:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:32984 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYE2Uri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:47:38 -0400
Date: Thu, 29 May 2008 14:47:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of	the kernel.
Message-ID: <20080529204736.GZ22636@parisc-linux.org>
References: <1211995212.3445.52.camel@localhost.localdomain> <20080528.225826.40264516.davem@davemloft.net> <1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu> <1212077700.26088.83.camel@shinybook.infradead.org> <20080529164745.GA21763@kroah.com> <483F1232.4010003@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483F1232.4010003@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 01:29:38PM -0700, Arjan van de Ven wrote:
> I very much would like to see a kernel-firmware or something tarbal that contains
> a copy of all relevant "freely distributable" firmware, that users can just install
> independent of the actual kernel version (and that kbuild would just pick up somehow).
> That way we can deal with a lot more firmware without having to pollute the kernel / kernel release process
> (after all, the timing is different in terms of releasing) while making it easy
> to get the lot of it.

There's definitely two schools of thought on this.  Sometimes firmware
changes (or adds) an interface.  If the kernel driver has to accommodate
new and old firmware, that adds complexity, and we all know that added
complexity means more bugs.  So I can definitely see some vendors
wanting to distribute their firmware with the kernel.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
