Return-Path: <linux-kernel-owner+w=401wt.eu-S1763370AbZANPWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763370AbZANPWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbZANPWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:22:38 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:58364 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468AbZANPWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:22:37 -0500
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KDGW12-03-7F9-01
Date: Wed, 14 Jan 2009 16:22:16 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 07/16] dma-debug: add debugfs interface
Message-ID: <20090114152216.GM20283@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-8-git-send-email-joerg.roedel@amd.com> <20090110230826.GJ17917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090110230826.GJ17917@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 14 Jan 2009 15:22:16.0478 (UTC) FILETIME=[E22273E0:01C9765B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 12:08:26AM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +/* Global error count */
> > +static u32 error_count;
> > +
> > +/* Global error show enable*/
> > +static u32 show_all_errors __read_mostly;
> > +/* Number of errors to show */
> > +static u32 show_num_errors = 1;
> > +
> >  static u32 num_free_entries;
> >  static u32 min_free_entries;
> 
> Small detail: please use native C types for non-hardware variables - 
> 'unsigned int', 'unsigned long', etc.
> 
> u32/u64 is typically used for variables where there is a real significance 
> to the precise width of the variable: there's either a hardware or a 
> user-space ABI involved.

There is some kind of userspace ABI: all these variables are exported
via debugfs. And debugfs relies on these types.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

