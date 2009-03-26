Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbZCZQhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbZCZQhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757523AbZCZQhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:37:21 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57499 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbZCZQhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:37:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=giZjPfbWlyQrAE4RN9JnGheMww+JYd9cI02WhuXCnA3aWN/QgIMxxqJYaSam5jSQAg
         byazcjE6cNAX5ao3OB4/ssCLI21MhsUgUYo7+7aNakrrumMCaGsuh0pjpB7dQ+ONcB3Q
         5Z9EM7e2sY729WQAO+xM7dEN9tTEXgSVph5+U=
Message-ID: <49CBAF36.1010203@gmail.com>
Date: Thu, 26 Mar 2009 17:37:10 +0100
From: =?UTF-8?B?Sm9zw6kgTWFyw63CrWEgRmVybsOhbmRleiBHb256w6FsZXo=?= 
	<josemariafg@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090323)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: Some microSD cards are not recognized by PCIxx12
 SDA controller
References: <49B5C091.3090303@gmail.com>	<20090324211748.30cd7429@mjolnir.ossman.eu>	<49C9E4B8.3000708@gmail.com> <20090325171749.62bd0fbb@mjolnir.ossman.eu>
In-Reply-To: <20090325171749.62bd0fbb@mjolnir.ossman.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Wed, 25 Mar 2009 09:00:56 +0100
> José Marí­a Fernández González <josemariafg@gmail.com> wrote:
> 
>> As I'm going to install 2.6.29 today, I can test the patch with it and HZ=100.
> 
> Please do. And try to determine where it breaks. I'd prefer if we don't
> need to increase this yet again in a month because we were relying on
> some scheduling latencies. :)
> 
> Rgds

I have been testing the patch with kernel 2.6.29 and a couple of cards (the Transcend 2GB microSD and a EZ Memory 8GB SDHC) in a few cases:

*	HZ=300 + tickless + desktop preemption
*	HZ=100 + tickless + desktop preemption
*	HZ=100 + desktop preemption
*	HZ=100 + low latency desktop preemption
*	HZ=1000 + tickless + desktop preemption

and it worked with no problem. I don't know if I have forgotten any obvious corner case. Perhaps I should have tested with no preemption...

	Best Regards,
		José María
