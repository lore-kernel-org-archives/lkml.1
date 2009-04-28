Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbZD1QHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbZD1QHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZD1QHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:07:01 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:51947
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751294AbZD1QG7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:06:59 -0400
X-BigFish: VPS-25(zz1432R98dR1805M936fK10d1Izz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KITJE8-02-4QJ-01
Date: Tue, 28 Apr 2009 18:06:12 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Greg KH <greg@kroah.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21] amd64_edac: EDAC module for AMD64
Message-ID: <20090428160612.GB7239@aftab>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com> <20090428155852.GA9956@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090428155852.GA9956@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 28 Apr 2009 16:06:12.0753 (UTC) FILETIME=[40701810:01C9C81B]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 08:58:52AM -0700, Greg KH wrote:
> On Tue, Apr 28, 2009 at 05:05:52PM +0200, Borislav Petkov wrote:
> > Hi Andrew,
> > hi Greg,
> > 
> > I think you've already heard about this driver, so here is a first
> > upstream submission request. It is quite sizable but partly the reason
> > for it is that it handles ECC detection and reporting for all AMD
> > K8, F10h and F11h families. It also implements DRAM error injection
> > functionality, failing DIMM module detection and some other fun stuff
> > found on F10h and later CPUs.
> > 
> > We've been doing testing/bugfixing/scrubbing here for some time, have
> > converted it to using kernel facilities and basically removed some slack
> > from it like glue code due to it being maintained out-of-tree. Please
> > take a look and let us know of any objections/comments you might have so
> > that we could tackle them on time.
> 
> At first glance, it looks sane to me.
> 
> Want me to put it in my driver tree so it can show up in -next?  Or is
> there some other tree you want to use?

-next should be just fine, let the code see some more testing :).

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

