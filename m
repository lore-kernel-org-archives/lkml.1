Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZIIBDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZIIBDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZIIBDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:03:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZIIBDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:03:01 -0400
Message-ID: <4AA6FEB5.9030507@zytor.com>
Date: Tue, 08 Sep 2009 18:02:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Jory A. Pratt" <anarchy@gentoo.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       hardened-dev@gentoo.org
Subject: Re: [PATCH] Fix cc1 options check to ensure we do not use -fPIC when
 compiling
References: <4AA6FB19.5020800@gentoo.org>
In-Reply-To: <4AA6FB19.5020800@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 05:47 PM, Jory A. Pratt wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> I have sent this to the lkml, it seems to have been pushed to the back
> burner. This is a major issue effecting users/developers that are
> working on a much more security enhanced system. This means any gentoo
> user running a hardened toolchain will have problems building a kernel
> that works as expect. This patch does nothing but pass the macro
> - -D__KERNEL__ to ensure that hardened toolchain drops back to that of a
> vanilla toolchain to prevent unexpected compile problems in the kernel.
> 

This should also be sent to the Kbuild maintainer, Sam Ravnborg
<sam@ravnborg.org>.

	-hpa
