Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbYD0Nhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbYD0Nhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 09:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYD0Nhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 09:37:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:45579 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbYD0Nhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 09:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UzxS3Zt04pXa407a2fkZnFw0bm7C6gCd7YMkLqJFQRhucTq/07IOs9o6N+Isks2PKEbuNniSG5Qv34TtGtnXkgD5YQudfsokICFDkOIha86CwoK/8tICKJLyfV1PvZBSuffc+xxxutFdt7ICE0HMk4pkGMsH6Hx+nGdCs/JpdXE=
Message-ID: <386072610804270637n68478a63mab9935fb935aaab5@mail.gmail.com>
Date: Sun, 27 Apr 2008 21:37:15 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] blackfin checksum annotations
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20080427124247.GV5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080427052226.GP5882@ZenIV.linux.org.uk>
	 <20080426.222644.74393287.davem@davemloft.net>
	 <20080427111623.GA6754@osiris.boeblingen.de.ibm.com>
	 <20080427124247.GV5882@ZenIV.linux.org.uk>
X-Google-Sender-Auth: 4cac2bc65c1537fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 8:42 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Apr 27, 2008 at 01:16:23PM +0200, Heiko Carstens wrote:
>
>  > I don't think such arch specific patches should go in via net-2.6.
>  > You did that for a very similar patch for s390 and it was subtly broken:
>  >
>  > See:
>  > f994aae1bd8e4813d59a2ed64d17585fe42d03fc
>  > ("[NET]: S390 checksum annotations and cleanups.")
>  >
>  > and
>  >
>  > afbc1e994ddcf3b6fe2dc928ee8dc31a5d0c3118
>  > ("[S390] Fix TCP/UDP pseudo header checksum computation.")
>
>  I remember, and AFAICT this one is safe - here everything stays within
>  C and type changes ought to be equivalent transformations.  Said that,
>  I do _NOT_ have hardware in question and it's completely untested at
>  runtime.
>

Sorry for the delay. I will test this patch on Blackfin arch. And if it is ok,
it will be merged to Blackfin git tree. As long as it is a Blackfin
arch related issue,
merging to Blackfin tree is a better way.

>  Al, who really couldn't care less which tree that goes through - up to
>  davem and blackfin maintainers; both are on Cc, so...
>

Thanks
-Bryan
