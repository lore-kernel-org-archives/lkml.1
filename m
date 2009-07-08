Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZGHEpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZGHEpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZGHEpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:45:36 -0400
Received: from smtp.nokia.com ([192.100.122.233]:42154 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZGHEpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:45:35 -0400
Message-ID: <4A542452.6060703@nokia.com>
Date: Wed, 08 Jul 2009 07:45:06 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: ubi tree build warnings
References: <20090708130921.a361f6d2.sfr@canb.auug.org.au>
In-Reply-To: <20090708130921.a361f6d2.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jul 2009 04:45:10.0632 (UTC) FILETIME=[E00B7E80:01C9FF86]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Stephen Rothwell wrote:
> Hi Artem,
> 
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> drivers/mtd/ubi/io.c: In function 'nor_erase_prepare':
> drivers/mtd/ubi/io.c:484: warning: passing argument 5 of 'ubi->mtd->write' from incompatible pointer type
> drivers/mtd/ubi/io.c:484: note: expected 'const u_char *' but argument is of type 'uint32_t *'
> drivers/mtd/ubi/io.c:486: warning: format '%zd' expects type 'signed size_t', but argument 5 has type 'int'
> drivers/mtd/ubi/io.c:486: warning: too many arguments for format
> drivers/mtd/ubi/io.c:493: warning: passing argument 5 of 'ubi->mtd->write' from incompatible pointer type
> drivers/mtd/ubi/io.c:493: note: expected 'const u_char *' but argument is of type 'uint32_t *'
> 
> Introduced by commit ebf53f421308c2f59c9bcbad4c5c297a0d00199a ("UBI: fix
> NOR flash recovery").

Will fix ASAP, thank you! I'm always wondering how you manage
to reproduce warnings I do not see.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
