Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYIMJuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYIMJuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 05:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbYIMJuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 05:50:02 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:43858 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755610AbYIMJuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 05:50:00 -0400
From: Frans Pop <elendil@planet.nl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Date: Sat, 13 Sep 2008 11:49:54 +0200
User-Agent: KMail/1.9.9
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <200809121533.43318.elendil@planet.nl> <7E82351C108FA840AB1866AC776AEC462CA8E8B0@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC462CA8E8B0@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Dz4yIYdXFToff4u"
Message-Id: <200809131149.55472.elendil@planet.nl>
X-OriginalArrivalTime: 13 Sep 2008 09:49:58.0148 (UTC) FILETIME=[15277C40:01C91586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Dz4yIYdXFToff4u
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 13 September 2008, Pallipadi, Venkatesh wrote:
> >We have too many entires in PAT list due to RAM pages being marked
> >UC by drivers. Unfortunately, there are no quick fixes that can fix
> >this for 2.6.27. However, we are aware of the problem here and
> >working on a more complete fix for this. We should have the patch
> >for it soon.
>
> Can you try the patch here
> http://www.ussg.iu.edu/hypermail/linux/kernel/0809.1/2074.html
> And report back whether that resolves the issue.

Yes, that solves the issue. The display is now free of artifacts again, 
both on logout and when I switch users in X.
The pat_memtype_list looks a lot more sane too (see attachment).

So it _was_ a regression caused by pat itself after all, and not the 
result of incorrect memory handling in the framebuffer code.
Could you take over the bug report #10843 in bugzilla (it is currently 
assigned to the framebuffer people) and ensure it gets closed once the 
patch gets accepted in Linus' tree?

I'm glad you were able to get this sorted out.

Feel free to add my:
Tested-by: Frans Pop <elendil@planet.nl>

Thanks,
FJP


--Boundary-00=_Dz4yIYdXFToff4u
Content-Type: text/plain;
  charset="iso-8859-1";
  name="pat_memtype_list"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="pat_memtype_list"

PAT memtype list:
uncached-minus @ 0x7f6e2000-0x7f6e3000
uncached-minus @ 0x7f6e4000-0x7f6e5000
uncached-minus @ 0x7f6f6000-0x7f6f7000
uncached-minus @ 0x7f6f6000-0x7f6f7000
uncached-minus @ 0x7f6f6000-0x7f6f7000
uncached-minus @ 0x7f6f6000-0x7f6f7000
uncached-minus @ 0x7f6f7000-0x7f6fc000
uncached-minus @ 0x7f6fc000-0x7f6fd000
uncached-minus @ 0x7f6fc000-0x7f6fd000
uncached-minus @ 0x7f6fc000-0x7f6fd000
uncached-minus @ 0x7f6fd000-0x7f6fe000
uncached-minus @ 0x7f6fd000-0x7f6fe000
uncached-minus @ 0x7f6fd000-0x7f6fe000
uncached-minus @ 0x7f6fd000-0x7f6fe000
uncached-minus @ 0x7f6fd000-0x7f6fe000
uncached-minus @ 0x80000000-0x90000000
uncached-minus @ 0x80000000-0x80020000
uncached-minus @ 0x80000000-0x80300000
uncached-minus @ 0x90100000-0x90120000
uncached-minus @ 0x90200000-0x90280000
uncached-minus @ 0x90200000-0x90280000
uncached-minus @ 0x90200000-0x90280000
uncached-minus @ 0x90280000-0x902c0000
uncached-minus @ 0x90280000-0x902c0000
uncached-minus @ 0x902c0000-0x902c4000
uncached-minus @ 0x902c4000-0x902c5000
uncached-minus @ 0x902c4000-0x902c5000
uncached-minus @ 0xfed00000-0xfed01000
uncached-minus @ 0xfed13000-0xfed14000
uncached-minus @ 0xfed1f000-0xfed20000
uncached-minus @ 0xfed40000-0xfed41000

--Boundary-00=_Dz4yIYdXFToff4u--
