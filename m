Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbXLLKwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbXLLKwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbXLLKwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:52:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758123AbXLLKwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:52:45 -0500
Date: Wed, 12 Dec 2007 02:52:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/47] CRIS patches for CRISv32 EtraxFS and ARTPEC-3
Message-Id: <20071212025212.51eed892.akpm@linux-foundation.org>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 17:02:22 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> Hi,
> 
> This patchset contains the differences to add support for the EtraxFS and
> ARTPEC-3 CPUs, both of the CRISv32 family.  Both chips can now be compiled
> with minimal configs.
> 
> To compile you'll need the Axis gcc cross port for CRISv32, it is mentioned
> in http://marc.info/?l=linux-kernel&m=119337976126184&w=2 how to get this.
> 
> Still missing to allow full compile is include/linux/mtd/mtdram.h,
> see http://marc.info/?l=linux-kernel&m=119373777301863&w=2
> 
> This is step two in syncing the Axis internal changes with mainline Linux,
> with the final goal being getting the CRIS port to the same level as
> the rest of the kernel.
> 
> I've tried to remove as much checkpatch warnings and errors as possible,
> but some remain, mostly (I think you'll agree) spurious warnings,
> although there's also a bunch of generated files which don't conform,
> but I hope to fix this at the source later on.
> 
> I realise this is a hefty chunk of code to review, but any suggestions
> on improvements are thankfully received.
> 
> The changes are also available in the export2 branch at
> 
> git://www.jni.nu/axis.git
> 

I don't think there's much point in me merging these.  Please ask Linus to
pull that tree once the 2.6.25 merge window opens.

