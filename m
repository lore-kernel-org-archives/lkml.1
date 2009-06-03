Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZFCIqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZFCIqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZFCIqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:46:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:63995 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZFCIqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:46:30 -0400
Message-ID: <4A26384A.6000906@nokia.com>
Date: Wed, 03 Jun 2009 11:46:02 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Pervushin <dpervushin@embeddedalley.com>
Subject: Re: linux-next: ubi tree build failure
References: <20090603184408.49c7fb1f.sfr@canb.auug.org.au>
In-Reply-To: <20090603184408.49c7fb1f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Jun 2009 08:46:07.0384 (UTC) FILETIME=[BC7B8980:01C9E427]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stephen Rothwell wrote:
> Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
> 
> drivers/mtd/ubi/gluebi.c: In function 'gluebi_get_device':
> drivers/mtd/ubi/gluebi.c:126: error: implicit declaration of function 'IS_ERR'
> drivers/mtd/ubi/gluebi.c:129: error: implicit declaration of function 'PTR_ERR'
> 
> Introduced by commit ec5c514efde253de7f28668c88bbae26d2a293de ("UBI: make
> gluebi a separate module") from the ubi tree.  I guess the conversion
> managed to remove an implicit include of linux/err.h.
> 
> I have reverted that commit for today.  I then needed to also revert
> commit 518ceef0c9ca97023e45ae46aedaefa240c690a6 ("UBI: remove built-in
> gluebi") to make it build again.

My fault. Will be fixed shortly, thank you!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
