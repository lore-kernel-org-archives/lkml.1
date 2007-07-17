Return-Path: <linux-kernel-owner+w=401wt.eu-S935520AbXGQWVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935520AbXGQWVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760097AbXGQWU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:20:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760068AbXGQWUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:20:55 -0400
Message-ID: <469D40BB.3030809@ce.jp.nec.com>
Date: Tue, 17 Jul 2007 18:20:43 -0400
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.23 PATCH 07/18] dm io: fix panic on large request
References: <20070711205846.GY24114@agk.fab.redhat.com> <469CC11B.2020103@trash.net> <469CF0CD.6060006@ce.jp.nec.com> <469D0159.1010506@trash.net>
In-Reply-To: <469D0159.1010506@trash.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Jun'ichi Nomura wrote:
>> Are you using other dm modules such as dm-multipath, dm-mirror
>> or dm-snapshot?
>> If so, can you take the output of 'dmsetup table' and 'dmsetup ls'?
> 
> No other modules.
> 
>> Do you have a reliable way to reproduce the oops which I can try?
> 
> "/etc/init.d/cryptdisk start" (debian) on a luks partition triggered
> it for me.

With today's git HEAD (commit 49c13b51a15f1ba9f6d47e26e4a3886c4f3931e2),
I tried the following but could not reproduce the oops here.
  # cryptsetup luksFormat /dev/sdb1
  # cryptsetup luksOpen /dev/sdb1 c
  # mkfs.ext3 /dev/mapper/c
  <mount it and do some I/O>

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

