Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbXHYDu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbXHYDu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 23:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXHYDuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 23:50:15 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:56125 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXHYDuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 23:50:13 -0400
Message-ID: <46CFA6F2.9030209@kernel.org>
Date: Fri, 24 Aug 2007 20:50:10 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>, Adrian Bunk <bunk@kernel.org>
CC: chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [2.6 patch] remove securebits
References: <20070824210649.GG30705@stusta.de> <20070824211942.GA24478@vino.hallyn.com>
In-Reply-To: <20070824211942.GA24478@vino.hallyn.com>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

FWIW, in the mm kernel, I've actually already removed them when one
configures without capabilities.

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/broken-out/v3-file-capabilities-alter-behavior-of-cap_setpcap.patch

Other than writing a custom module, so far as I can tell, there is/was
no way to set them anyway.

I'd obviously prefer to wait for the mm-merge process to complete and
minimize the churn in this area, but I basically agree that the bits as
implemented are pretty useless in their current form. In a per-process
mode (with filesystem capability support) they are much more useful...

Cheers

Andrew

Serge E. Hallyn wrote:
> Quoting Adrian Bunk (bunk@kernel.org):
>> It seems that since it was added in kernel 2.2.0 (sic) securebits 
>> was never used.
>>
>> This patch therefore removes it.
> 
> Actually IIUC Andrew Morgan had plans of making securebits per-process,
> which would make them far more usable.
> 
> Now maybe he'd just as soon start with a clean slate...  Andrew?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFGz6bwQheEq9QabfIRAjx5AKCZSFZ0dv4HTUtUYtm6OdVlOUi3ewCdGHzE
TnoeF19cOljfiyntgkcSCbE=
=lW84
-----END PGP SIGNATURE-----
