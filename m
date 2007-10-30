Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbXJ3Tha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbXJ3Tha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXJ3ThU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:37:20 -0400
Received: from ns1.suse.de ([195.135.220.2]:41799 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbXJ3ThT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:37:19 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Date: Tue, 30 Oct 2007 20:37:14 +0100
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       rajesh.shah@intel.com, linux-kernel <linux-kernel@vger.kernel.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <200710301950.58519.ak@suse.de> <alpine.LFD.0.999.0710301205180.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710301205180.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710302037.14418.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 20:06:12 Linus Torvalds wrote:
> 
> On Tue, 30 Oct 2007, Andi Kleen wrote:
> > 
> > Also there are still the old x86 Macs where conf1 doesn't work.
> 
> I don't think that was ever true. That was a made-up rumor by the EFI 
> people who were just confused.
> There's no way to disable conf1 accesses on any known chipset, afaik.

There was a tester with such a machine and he complained until
the heuristic handled this case.  So there is evidence it 
really was like this.

-Andi
