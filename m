Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYG2Xnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYG2Xnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbYG2Xnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:43:40 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:53620 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755453AbYG2Xnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:43:40 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: "David Wilson" <mcs6502@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pci_ids.h - duplicate entry and many out of order definitions
Date: Wed, 30 Jul 2008 09:43:28 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <sdav849lsbk5k4m3attufmvvu7cl11mh26@4ax.com>
References: <3666888f0807291600n3c259c20wccc4896b2df3d0d8@mail.gmail.com>
In-Reply-To: <3666888f0807291600n3c259c20wccc4896b2df3d0d8@mail.gmail.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 09:00:09 +1000, "David Wilson" <mcs6502@gmail.com> wrote:

>I was browsing the pci_ids.h file and came across a duplicate entry
>for PCI_VENDOR_ID_RDC. This prompted me to look further and I found a
>number of out-of-order definitions (based on the comment at the head
>of the file that indicates that they should be sorted). I decided to
>write a script to check this and it found 74 "errors".
>
>1) Is it worth my time generating a patch to fix all these mis-orderings?
>2) Should it be one large patch or many small ones (eg one per PCI_VENDOR)?
>3) Is there a maintainer for this file?

Dunno about a maintainer, I did a cleanup over the thing a couple years 
ago and GregKH was taking the patches.  

Also need to check that people not making PCI_* names up with macros in 
drivers as that reduces grep usability.  

Think there's a new PCI maintainer now?

Grant.
