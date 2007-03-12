Return-Path: <linux-kernel-owner+w=401wt.eu-S965829AbXCLNGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829AbXCLNGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965839AbXCLNGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:06:46 -0400
Received: from ns1.suse.de ([195.135.220.2]:36123 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965829AbXCLNGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:06:45 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: data corruption with nvidia chipsets and IDE/SATA drives (k8 cpu errata needed?)
Date: Mon, 12 Mar 2007 14:06:33 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Chip Coldwell <coldwell@redhat.com>
References: <fa.Tb2r8Il/2H8l9dhmsGAAQB2WEZg@ifi.uio.no> <fa.lphwLNvMksoBFaqfqCzMG1UVhsA@ifi.uio.no> <45EBB7C5.2010407@shaw.ca>
In-Reply-To: <45EBB7C5.2010407@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121406.33334.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Andi, have you had a look at this? I'm a bit surprised at the lack of 
> reaction to this find..


FYI the problem is still being analysed behind the scenes. Chip's patch didn't fix 
it in all cases unfortunately -- it just changed the timing enough to make it happen
less often. The latest evidence points to a DMA mapping management problem
in Linux. Apparently in some cases sata_nv does DMA on an already freed and then
reused mapping.

-Andi
