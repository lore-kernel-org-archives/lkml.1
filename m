Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZETRSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZETRSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbZETRSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:18:03 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:27418
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754209AbZETRSC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:18:02 -0400
X-BigFish: VPS-11(zz146fK98dRzz1202hzzz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJYDDN-01-76X-01
Date: Wed, 20 May 2009 19:17:54 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: linux-next: Tree for May 20 (amd64_edac)
Message-ID: <20090520171754.GB29913@aftab>
References: <20090520170807.b75a9d86.sfr@canb.auug.org.au> <4A142CC9.4050904@oracle.com> <20090520164112.GA29913@aftab> <4A14352C.5020508@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A14352C.5020508@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 20 May 2009 17:17:52.0641 (UTC) FILETIME=[E8756F10:01C9D96E]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 20, 2009 at 09:51:56AM -0700, Randy Dunlap wrote:

[..]

> Distros don't use defaults or defconfig anyway, and having them
> enabled bloats kernels.  I'm sure that Linus has also expressed
> opinions about enabling options in this way, but I can't find it
> just now.

This is one of those situations where you have the pros and the cons
staring at you. For what is worth, I myself have sent several patches
removing Kconfig options defaulting to m for hardware which is not even
present on a two-digit percentage of machines. I was told then, that it
is defaulting to m so that the code sees some more compiles on different
hardware but we end up automating stuff to turn them off in the .config
and the whole thing doesn't serve its purpose in the end anyway.

Besides, those who enable EDAC should probably know what they need to
turn on, in addition to that. Also, the bloating part is not good(tm).

So off it is...

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

