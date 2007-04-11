Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbXDKNsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbXDKNsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 09:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXDKNsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 09:48:08 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:35756 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXDKNsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 09:48:07 -0400
Message-ID: <461CE6AA.6050806@gmail.com>
Date: Wed, 11 Apr 2007 15:46:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: corentincj@iksaif.net
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sziwan@users.sourceforge.net, acpi4asus-user@lists.sourceforge.net,
       len.brown@intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
References: <22473653910004885@karneval.cz> <200704111505.03625.corentincj@iksaif.net>
In-Reply-To: <200704111505.03625.corentincj@iksaif.net>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 11 Apr 2007 15:47:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Corentin CHARY napsal(a):
> Le Wednesday 11 April 2007 11:33:48 Jiri Slaby, vous avez écrit :
>> asus_acpi, support F2JE model
> Just use the new asus-laptop driver =)
> (see acpi4asus-0.40)

code seems good, but this is not so good:
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
#warning "This module does not support 2.6.20 yet, wait for a new release =)"
#endif

When do you plan to support latest kernels and merge it to mainline?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
