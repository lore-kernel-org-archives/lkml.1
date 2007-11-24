Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbXKXPVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbXKXPVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 10:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbXKXPVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 10:21:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54356 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXKXPVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 10:21:12 -0500
Message-ID: <474840E9.4080602@anagramm.de>
Date: Sat, 24 Nov 2007 16:19:05 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: wuhm <wuhm@hisome.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: HELP: Internal error: Oops: f5 [#1]
References: <1195908103.857.1.camel@wuhm-laptop.dev.hisome.com>
In-Reply-To: <1195908103.857.1.camel@wuhm-laptop.dev.hisome.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18pQkp6Kjqzvi2LDkZzWT5a6Mkwg1wpOZAFU3j
 SPQEivBf95Vpsj7tOcfoOjht6j+0BPW9YsbingGMmypIgxkUFW
 v2Zv9PQ5YeOUf9VdjSnzg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

wuhm schrieb:
> Unable to handle kernel paging request at virtual address c3c00000
> pgd = c3a5c000
> [c3c00000] *pgd=00000000
> Internal error: Oops: f5 [#1]
> Modules linked in: dm642 mv_sata ixp400_eth ixp400

dm642 is an out-of-tree module. Contact the author of that module.

> CPU: 0
> PC is at .c2u_0cpynopld+0x8/0x24
> LR is at mpeg_read+0x19c/0x35c [dm642]
> pc : [<c0106934>]    lr : [<bf0c8a98>]    Tainted: P

Your Kernel is tainted. The proprietary module seems to crash.
You won't get help from us regarding this module.

Please read:
http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html

Regards,
-- 
Clemens Koller
_______________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Str. 45/1
81379 Muenchen
Germany

http://www.anagramm-technology.com
Phone: +49-89-741518-50
Fax: +49-89-741518-19
