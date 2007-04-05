Return-Path: <linux-kernel-owner+w=401wt.eu-S1767217AbXDESzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767217AbXDESzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767221AbXDESzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:55:20 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:54375 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767217AbXDESzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:55:19 -0400
X-AuditID: d80ac287-91523bb000000c42-71-46154616be7a 
Date: Thu, 5 Apr 2007 19:54:58 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Pat <patchu1@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Invalid operand: kernel BUG at mm/rmap.c:434! and
 arch/i386/mm/highmem.c:42!)
In-Reply-To: <702654.55872.qm@web32508.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0704051949280.20591@blonde.wat.veritas.com>
References: <702654.55872.qm@web32508.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 05 Apr 2007 18:55:17.0895 (UTC) FILETIME=[F3F26970:01C777B3]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007, Pat wrote:
> Yes, there is a specific app which seems to be related
> to the kernel panic. 
> 
> We use a few third party drivers on the system, so my
> initial suspicions were on: 3w_9xxx(U) which is the
> RAID card driver and fusedriver(U) which is a hardware
> PCI card driver. 
> 
> The app which is kernel panicing is the only
> application which makes use of the fusedriver. I'd
> like to confirm my suspicions on the driver. Do you
> have any suggestions on how I could trace the kernel
> panic to that specific driver?

Indeed, yes, get its source and look to see what it's doing
with PageReserved - or mail it to me privately and I'll take
a look.  But my Google for fusedriver didn't show anything,
and clearly it has nothing to do with the FUSE filesystems.

Hugh
