Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZCFNIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZCFNIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZCFNIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:08:07 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:15073
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751919AbZCFNIG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:08:06 -0500
X-BigFish: VPS-27(zz1432R98dR1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KG35SS-03-1FK-01
Date: Fri, 6 Mar 2009 14:07:40 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: Joerg Roedel <joro@8bytes.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][GIT PULL] dma-api debugging facility
Message-ID: <20090306130740.GI8751@amd.com>
References: <20090305200338.GA31182@amd.com> <20090306055944Q.fujita.tomonori@lab.ntt.co.jp> <20090305223302.GN2125@8bytes.org> <20090305232219.GG24280@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090305232219.GG24280@sequoia.sous-sol.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 06 Mar 2009 13:07:41.0001 (UTC) FILETIME=[87D7B390:01C99E5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 03:22:19PM -0800, Chris Wright wrote:
> * Joerg Roedel (joro@8bytes.org) wrote:
> > Thats fixed in the tree above. I will send out the patches tomorrow
> > seperatly for easier reviewing and commenting.
> 
> Did you fix the incorrect usage of __cacheline_aligned_in_smp?
> 
> essentially:
> 
> -} __cacheline_aligned_in_smp;
> +} ____cacheline_aligned_in_smp;

Yes. This is fixed in the tree too.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

