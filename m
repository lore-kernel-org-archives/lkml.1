Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZEUUae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZEUUae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZEUUa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:30:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45151 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbZEUUaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:30:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A15B9CC.9030001@s5r6.in-berlin.de>
Date: Thu, 21 May 2009 22:30:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       krh@redhat.com
Subject: Re: [PATCH 2/5] fs: Remove i_cindex from struct inode
References: <1242936063-31689-1-git-send-email-tytso@mit.edu> <1242936063-31689-2-git-send-email-tytso@mit.edu> <1242936063-31689-3-git-send-email-tytso@mit.edu>
In-Reply-To: <1242936063-31689-3-git-send-email-tytso@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o wrote:
[...]
> The firewire driver does not need i_cindex in any fast path, so it's
> simple enough to calculate when it is needed, instead of wasting space
> in the inode structure.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: krh@redhat.com
> Cc: stefanr@s5r6.in-berlin.de
> Cc: linux-fsdevel@vger.kernel.org
> ---
>  drivers/ieee1394/dv1394.c        |    5 +++--
>  drivers/ieee1394/ieee1394_core.h |    5 ++++-
>  fs/char_dev.c                    |   14 +++++++++++++-
>  include/linux/cdev.h             |    2 ++
>  include/linux/fs.h               |    1 -
>  5 files changed, 22 insertions(+), 5 deletions(-)
[...]

Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

(No Ack needed from krh, he is concerned with drivers/firewire, not 
really with driver/ieee1394. :-)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
