Return-Path: <linux-kernel-owner+w=401wt.eu-S966149AbXDCCPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966149AbXDCCPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 22:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966151AbXDCCPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 22:15:32 -0400
Received: from gum.itee.uq.edu.au ([130.102.66.1]:46887 "EHLO
	gum.itee.uq.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966149AbXDCCPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 22:15:31 -0400
Message-ID: <4611B8BA.6000406@itee.uq.edu.au>
Date: Tue, 03 Apr 2007 12:15:22 +1000
From: John Williams <jwilliams@itee.uq.edu.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060418 Red Hat/1.7.13-1.1.3.1.centos3
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: ENOENT creating /dev/root on MTD RAM partition
References: <4610A598.4050206@itee.uq.edu.au> <20070402125212.GA11522@aepfle.de>
In-Reply-To: <20070402125212.GA11522@aepfle.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> On Mon, Apr 02, John Williams wrote:
> 
>>Any comments or suggestions on a possible cause or approach to track it
>>down would be greatly appreciated.
> 
> Just a guess:
> Check if '/dev' exists. I think it is now possible to not add the built-in
> cpio archive with the mandatory /dev, /dev/console and /root entries.

Thanks Olaf - you got me on the right track.  Turned out to be an arch 
link script error whereby the "rootfs" initcalls were not placed in the 
initcall table - thus the init ramfs wasn't yet mounted, and /dev wasn't 
there.

Cheers,

John
