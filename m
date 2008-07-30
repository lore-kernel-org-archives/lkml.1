Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbYG3KnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbYG3KnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYG3Km6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:42:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbYG3Km6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:42:58 -0400
Date: Wed, 30 Jul 2008 03:42:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mcs6502@gmail.com
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch 00/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs
 within VENDOR_IDs
Message-Id: <20080730034255.ac5aa6c2.akpm@linux-foundation.org>
In-Reply-To: <E1KO7OU-0007BT-Ff@wraith.cs.uow.edu.au>
References: <E1KO7OU-0007BT-Ff@wraith.cs.uow.edu.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 18:50:50 +1000 mcs6502@gmail.com wrote:

> From: mcs6502@gmail.com
> To: unlisted-recipients:;;@imap1.linux-foundation.org (no To-header on input)

Something went wrong with the From: and To: lines.

Jesse wasn't cc'ed?

> Subject: [patch 00/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs

a) the patch title shouldn't include the kernel version - that
   information becomes instantly irrelevant (and soon wrong) as soon as
   someone merges the patch.

   It is sometimes useful to include this information, but it should
   be inside [], so the patch recipient can automatically remove it.

   (otoh, the patch _should_ be against latest Linus mainline, so
   it's not very useful info).

b) all 31 patches had the same title.  This causes numerous
   problems.  Please think up unique and relevant titles for each
   patch.

> Date: 	Wed, 30 Jul 2008 18:50:50 +1000
> Sender: linux-kernel-owner@vger.kernel.org
> 
> The following 31 patches attempt to bring pci_ids.h back into order.

This patchset will be utterly ghastly for someone to maintain for two
months.  The PCI and linux-next trees will be worst hit.

So we either

a) slam it into mainline immediately or

b) ask you to regenerate it during the 2.6.28 merge window or

c) forget the whole idea.

