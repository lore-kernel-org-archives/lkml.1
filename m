Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYEOHsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYEOHsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYEOHsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:48:00 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33107 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYEOHr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:47:58 -0400
Message-ID: <482BEA9A.3010006@ak.jp.nec.com>
Date: Thu, 15 May 2008 16:47:38 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morgan <morgan@kernel.org>
CC: Chris Wright <chrisw@sous-sol.org>, greg@kroah.com, serue@us.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] exporting capability name/code pairs (for 2.6.26)
References: <47C25AE9.7080305@ak.jp.nec.com> <480DC80F.3060403@ak.jp.nec.com> <20080423053726.GF3861@localhost.localdomain> <480EE1F6.3070205@ak.jp.nec.com> <482A33FA.5030109@ak.jp.nec.com> <20080514005238.GZ17453@sequoia.sous-sol.org> <482A7F64.50705@ak.jp.nec.com> <482BCEB4.9050906@kernel.org>
In-Reply-To: <482BCEB4.9050906@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> KaiGai Kohei wrote:
> | For example, we got CAP_MAC_ADMIN at 2.6.25. If an application tries to
> | use it, we have to replace libcap for 2.6.24 by libcap for 2.6.25.
> | Although, we don't get any updates in libcap. :-(
> 
> I'm not sure what you mean here. I think you will find that this
> particular capability was supported in libcap 2.03. Current is 2.09.

What I wanted to say is that we have to update/rebuild/reinstall
userland packages using arbitary number of capabilities (like libcap)
whenever the newer kernel adds a new capability, however, is it really
necessary?

Thanks,

> Also, having Ack'd your proposed kernel patch, I speculatively included
> support for it in libcap-2.08. I will, of course, remove this support if
> the kernel doesn't adopt your change - or picks a different strategy...
> As it is, the patched kernel works nicely. :-)
> 
> http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/
> 
> Cheers
> 
> Andrew
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (Darwin)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
> 
> iD4DBQFIK86y+bHCR3gb8jsRAnV4AJ9gCaTwfKs8r7KX4DFixT84A5buOQCYlbaX
> mnMx52Yt2pRcLAXTOXElLA==
> =31Cy
> -----END PGP SIGNATURE-----

-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
