Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbXHNKtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbXHNKtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbXHNKsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:48:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbXHNKsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:48:51 -0400
Message-ID: <46C1888E.4060501@redhat.com>
Date: Tue, 14 Aug 2007 12:48:46 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, akpm@linux-foundation.org,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] [153/2many] MAINTAINERS - DEVICE-MAPPER  (LVM)
References: <46bff986.szARdClTcYqQa8So%joe@perches.com>
In-Reply-To: <46bff986.szARdClTcYqQa8So%joe@perches.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ea991f0..36a7d25 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1472,6 +1472,7 @@ P:	Alasdair Kergon
>  L:	dm-devel@redhat.com
>  W:	http://sources.redhat.com/dm
>  S:	Maintained
> +F:	drivers/md/dm*

File pattern should be:

F:	drivers/md/dm*
F:	drivers/md/kcopyd*
F:	include/linux/device-mapper.h
F:	include/linux/dm-ioctl.h
F:	Documentation/device-mapper/

--
mbroz@redhat.com
