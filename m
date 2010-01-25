Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983Ab0AYPyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0AYPyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497Ab0AYPyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:54:23 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:23852 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0AYPyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:54:22 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zz1432R98dNzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KWT867-02-569-02
X-M-MSG: 
Date: Mon, 25 Jan 2010 16:54:08 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, fweisbec@gmail.com,
       dan.j.williams@intel.com, ying.huang@intel.com, lenb@kernel.org,
       neilb@suse.de, cl@linux-foundation.org
Subject: Re: [PATCH 8/8] percpu: add __percpu sparse annotations to what's
 left
Message-ID: <20100125155408.GF14274@aftab>
References: <1264432935-10453-1-git-send-email-tj@kernel.org>
 <1264432935-10453-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1264432935-10453-9-git-send-email-tj@kernel.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 25 Jan 2010 15:53:50.0755 (UTC) FILETIME=[96882F30:01CA9DD6]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 12:22:15AM +0900, Tejun Heo wrote:
> Add __percpu sparse annotations to places which didn't make it in one
> of the previous patches.  All converions are trivial.
> 
> These annotations are to make sparse consider percpu variables to be
> in a different address space and warn if accessed without going
> through percpu accessors.  This patch doesn't affect normal builds.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Neil Brown <neilb@suse.de>
> ---
>  crypto/cryptd.c                  |    2 +-
>  drivers/acpi/processor_perflib.c |    2 +-
>  drivers/dma/dmaengine.c          |    2 +-
>  drivers/edac/amd64_edac.c        |    2 +-

For the edac bits:

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

