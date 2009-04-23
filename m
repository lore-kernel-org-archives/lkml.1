Return-Path: <linux-kernel-owner+w=401wt.eu-S1751552AbZDWHH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbZDWHH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZDWHHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:07:15 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:40547 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZDWHHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:07:13 -0400
Date: Thu, 23 Apr 2009 00:07:13 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense: Logical block address out of range, sector 0
Message-ID: <20090423070713.GF19113@hexapodia.org>
References: <20090421015234.GA7014@hexapodia.org> <20090422144904.407df635.akpm@linux-foundation.org> <49F00EBB.7040504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F00EBB.7040504@gmail.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 12:46:19AM -0600, Robert Hancock wrote:
> >Oh well, let's tentatively assume that we have a post-2.6.29 regression
> >in the libata ahci driver.
> 
> I tend to doubt it's a problem in ahci itself, I would guess it's higher 
> up the stack. Or could be that it's not a kernel bug, just some change 
> in timing that triggers the problem.
> 
> What's supposed to stop udev/hal from poking at the drive while wodim is 
> writing to the disc, anyway?

wodim opens O_EXCL, and it does occasionally complain about not being
able to open, then sleeping and retrying.

-andy
