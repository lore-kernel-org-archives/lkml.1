Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbZEMKuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbZEMKuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbZEMKuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:50:20 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:56071 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbZEMKuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:50:18 -0400
Message-ID: <4A0AA5DA.6090705@suse.de>
Date: Wed, 13 May 2009 16:20:02 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Holger Kiehl <Holger.Kiehl@dwd.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: NFS write OOPS with 2.6.29.2
References: <Pine.LNX.4.64.0905031552340.1774@praktifix.dwd.de>	 <20090504231426.2e5a51b0.akpm@linux-foundation.org>	 <Pine.LNX.4.64.0905091913010.3181@praktifix.dwd.de>	 <1241929074.5149.1.camel@heimdal.trondhjem.org>	 <Pine.LNX.4.64.0905110919490.27423@praktifix.dwd.de>	 <1242044201.6691.4.camel@heimdal.trondhjem.org>	 <Pine.LNX.4.64.0905111240190.27423@praktifix.dwd.de> <1242046675.6691.6.camel@heimdal.trondhjem.org>
In-Reply-To: <1242046675.6691.6.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Mon, 2009-05-11 at 12:45 +0000, Holger Kiehl wrote:
>> On Mon, 11 May 2009, Trond Myklebust wrote:
>>>
>> Thanks! Now it works. One more problem I have is with splice(). My
>> application reports the following error:
>>
>>     splice() error : Invalid argument
>>
>> When it is called as follows:
>>
>>      if ((bytes_written = splice(fd_pipe[0], NULL, to_fd,
>>                                  NULL, bytes_read,
>>                                  SPLICE_F_MOVE | SPLICE_F_MORE)) == -1)
>>
>> Or may I not use splice() over NFS?
> 
> The read part is there, but the write part is still missing (just an
> oversight - implementing it is pretty trivial). I'm planning on fixing
> that for 2.6.31.
> 

Did my latest respun look OK?

http://lkml.org/lkml/2009/4/22/70


Thanks,

-- 
Suresh Jayaraman
