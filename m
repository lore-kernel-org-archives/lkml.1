Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbYJMPNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbYJMPNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYJMPNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:13:35 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:15473 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYJMPNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:13:34 -0400
X-BigFish: VPS-48(z34a4lz62a3L1432R9370P98dR936eQ1805M936fOzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8ONM2-02-PL8-01
Date: Mon, 13 Oct 2008 17:13:07 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev@ozlabs.org, benh@kernel.crashing.org
Subject: Re: [Cbe-oss-dev] powerpc/cell/oprofile: fix mutex locking for
	spu-oprofile
Message-ID: <20081013151307.GA23557@erda.amd.com>
References: <1217620879.15667.145.camel@carll-linux-desktop> <18610.20951.764057.574721@cargo.ozlabs.ibm.com> <200808250955.57638.arnd@arndb.de> <200810131653.29631.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200810131653.29631.arnd@arndb.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Oct 2008 15:13:20.0694 (UTC) FILETIME=[3A5D8D60:01C92D46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.10.08 16:53:28, Arnd Bergmann wrote:
> On Monday 25 August 2008, Arnd Bergmann wrote:
> > On Monday 25 August 2008, Paul Mackerras wrote:
> > > 
> > > > Since rc4 is out now, I understand if you feel more comfortable with
> > > > putting the patch into -next instead of -merge.
> > > 
> > > Linus has been getting stricter about only putting in fixes for
> > > regressions and serious bugs (see his recent email to Dave Airlie on
> > > LKML for instance).  I assume that the corruption is just in the data
> > > that is supplied to userspace and doesn't extend to any kernel data
> > > structures.
> > 
> > That's right, please queue it for -next then.
> 
> I just realized that this patch never made it into powerpc-next after
> all, neither benh nor paulus version. Whoever is handling it today,
> could you please pull
> 
>  master.kernel.org:/pub/scm/linux/kernel/git/arnd/cell-2.6.git merge
> 
> to get this commit below. I have rebased it on top of the current
> benh/powerpc/next branch.

All powerpc oprofile patches are in this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git powerpc-for-paul

Pending patches are:

Carl Love (1):
      powerpc/cell/oprofile: fix mutex locking for spu-oprofile

Roel Kluin (1):
      powerpc/cell/oprofile: vma_map: fix test on overlay_tbl_offset

Please pull from there.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

