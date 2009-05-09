Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZEITRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZEITRH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 15:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZEITQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 15:16:55 -0400
Received: from dwdmx5.dwd.de ([141.38.3.242]:51655 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbZEITQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 15:16:54 -0400
Date: Sat, 9 May 2009 19:16:49 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@praktifix.dwd.de
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: NFS write OOPS with 2.6.29.2
In-Reply-To: <20090504231426.2e5a51b0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0905091913010.3181@praktifix.dwd.de>
References: <Pine.LNX.4.64.0905031552340.1774@praktifix.dwd.de>
 <20090504231426.2e5a51b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Andrew Morton wrote:

>
> (cc linux-nfs)
>
> On Sun, 3 May 2009 16:03:38 +0000 (GMT) Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>
>> Hello
>>
>> With plain kernel 2.6.29.2 I get the following OOPS (several of them) when
>> writing lots of small files on the client system:
>>
>>     May  3 18:48:34 obelix kernel: ------------[ cut here ]------------
>>     May  3 18:48:34 obelix kernel: kernel BUG at fs/nfs/write.c:252!
>
> I think this is a well-know bug, and fixes should be available in 2.6.29.3?
>
Thanks for this information. I just tried 2.6.29.3 and it still oopses.
Are there any patches I can try?

Thanks,
Holger
