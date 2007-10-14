Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXJNTqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXJNTqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 15:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbXJNTqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 15:46:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50682 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbXJNTqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 15:46:16 -0400
Date: Sun, 14 Oct 2007 21:46:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: In response to kernel compression e-mail a few months ago.
In-Reply-To: <Pine.LNX.4.64.0710141533080.3935@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0710142144340.22801@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710141533080.3935@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 14 2007 15:34, Justin Piszcz wrote:
>
> It turns out the one I did not test, was actually the best:
>
> Used: 7z -mx=9 a linux-2.6.16.17.tar.7z linux-2.6.16.17.tar
>
> $ du -sk * | sort -n
> 32392 linux-2.6.16.17.tar.7z
> 33520 linux-2.6.16.17.tar.lzma
> 33760 linux-2.6.16.17.tar.rar
> 38064 linux-2.6.16.17.tar.rz
> 39472 linux-2.6.16.17.tar.szip
> 39520 linux-2.6.16.17.tar.bz
> 39936 linux-2.6.16.17.tar.bz2
> 40000 linux-2.6.16.17.tar.bicom
> 40656 linux-2.6.16.17.tar.sit
> 47664 linux-2.6.16.17.tar.lha
> 49968 linux-2.6.16.17.tar.dzip
> 50000 linux-2.6.16.17.tar.gz
> 51344 linux-2.6.16.17.tar.arj
> 57552 linux-2.6.16.17.tar.lzo
> 57984 linux-2.6.16.17.tar.F
> 81136 linux-2.6.16.17.tar.Z
> 94544 linux-2.6.16.17.tar.zoo
> 101216 linux-2.6.16.17.tar.arc
> 228608 linux-2.6.16.17.tar

What's with all these odd formats, and where is .zip? :)
Somehow... have you tried lrzip?
Furthermore, if the files in the .tar archive were actually sorted..
(Obviously we shall pick .7z)
