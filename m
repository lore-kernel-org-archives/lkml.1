Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZETJn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZETJn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbZETJns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:43:48 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:48568 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZETJnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:43:46 -0400
X-BigFish: VPS-22(zz1432R98dR1805Mzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJXSBZ-03-2JM-01
Date: Wed, 20 May 2009 11:43:10 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>, Weidong Han <weidong.han@intel.com>,
       dwmw2@infradead.org, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
Message-ID: <20090520094310.GF9835@amd.com>
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com> <1242757912-6041-3-git-send-email-weidong.han@intel.com> <20090519115055.GB14305@elte.hu> <m1k54cj3iz.fsf@fess.ebiederm.org> <20090520082114.GC6736@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090520082114.GC6736@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 May 2009 09:43:11.0008 (UTC) FILETIME=[63569A00:01C9D92F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 10:21:14AM +0200, Ingo Molnar wrote:
> 
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Being a major nitpick, I have to point out that the code is not 
> > structured to support other iommus, and I think AMD has one that 
> > can do this as well.
> 
> (Joerg Cc:-ed)

The AMD IOMMU does also have an interrupt remapping feature. But it is
currently unsupported in the Linux driver. When this is going to be
implemented I think we can go the same way as for device passthrough in
KVM. This was an Intel-only feature too and was later adapted to support
AMD IOMMU too.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

