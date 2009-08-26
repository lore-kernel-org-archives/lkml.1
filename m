Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZHZDdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZHZDdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 23:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbZHZDdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 23:33:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485AbZHZDdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 23:33:08 -0400
Message-ID: <4A94ACDF.30405@redhat.com>
Date: Tue, 25 Aug 2009 23:32:47 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
References: <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com> <20090825093414.GB15563@elf.ucw.cz>
In-Reply-To: <20090825093414.GB15563@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

>> So, would you be happy if ext3 fsck was always run on reboot (at least  
>> for flash devices)?
> 
> For flash devices, MD Raid 5 and anything else that needs it; yes that
> would make me happy ;-).

Sorry, but that just shows your naivete.

Metadata takes up such a small part of the disk that fscking
it and finding it to be OK is absolutely no guarantee that
the data on the filesystem has not been horribly mangled.

Personally, what I care about is my data.

The metadata is just a way to get to my data, while the data
is actually important.

-- 
All rights reversed.
