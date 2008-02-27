Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbYB0Rp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbYB0Rp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbYB0RpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:45:17 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:16460 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbYB0RpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:45:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tbdbQCaL63bHj1jiy//OpqZ19/ZSVxFq6EnhDFmqm4d81ZgLMmCQLnHC+xB/PKXfzAvVoDybWfBl1S/w5Oje5EFO29qXUto3Eu1aiF7iA/voBnGne3B+zLGEVSDSBL9NuLBmnM1keK5suvwf/BdakHEqG6IMWibqdOy373OBF7Y=
Message-ID: <c6b1100b0802270945l1a7fcca9uea4c38a2057230aa@mail.gmail.com>
Date: Wed, 27 Feb 2008 17:45:13 +0000
From: "Chris Clayton" <chris2553@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Cc: "Stefano Brivio" <stefano.brivio@polimi.it>, ivdoorn@gmail.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       johannes@sipsolutions.net
In-Reply-To: <20080227172546.GD3078@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com>
	 <200802261911.39577.chris2553@googlemail.com>
	 <20080226194838.GD3013@tuxdriver.com>
	 <c6b1100b0802261313v12fb9cd5j6501e80f6d071019@mail.gmail.com>
	 <20080226223814.4ef2b435@morte>
	 <c6b1100b0802261436i7c5a4136j753501933037187@mail.gmail.com>
	 <20080227082642.218b8014@morte> <20080227155111.GB3078@tuxdriver.com>
	 <20080227172546.GD3078@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/2008, John W. Linville <linville@tuxdriver.com> wrote:
> On Wed, Feb 27, 2008 at 10:51:11AM -0500, John W. Linville wrote:
>  > On Wed, Feb 27, 2008 at 08:26:42AM +0100, Stefano Brivio wrote:
>  > > On Tue, 26 Feb 2008 22:36:19 +0000
[...]
>  > >
>  > > Known and fixed. The fix isn't in 2.6.25-rc3 yet, though.
>  > >
>  > > Fix:
>  > > commit 32720eae675d08990e97bffbf71a31382599cc8a
>  > > Author: Stefano Brivio <stefano.brivio@polimi.it>
>  > > Date:   Tue Jan 29 20:29:16 2008 +0100
>  > >
>  > >     rc80211-pid: fix rate adjustment
>  >
>  > And it currently isn't queued for 2.6.25 at all.
>  >
>  > Chris, can you cherry-pick this from the wireless-2.6.26 tree and
>  > give it a test on your 2.6.25-rc3 tree?  If it resolves a problem
>  > then I'll queue it to Dave for 2.6.25 (which will probably provoke
>  > a net-2.6.26 and wireless-2.6.26 rebase).
>
>
> That might be easier said than done.  It looks like that patch depends
>  on the big cfg80211 API change queued for 2.6.26.
>

Yes, that's correct. The patch doesn't apply cleanly to -rc3 and,
having inspected at it, it looks too complicated for me to hack in.

>  Stefano offered to rebase that on 2.6.25.  Stefano, could you post
>  that as part of this thread?
>

That would be very helpful.

Thanks
>  Thanks,
>
>
>  John
>  --
>  John W. Linville
>  linville@tuxdriver.com
>


-- 
Beauty is in the eye of the beerholder.
