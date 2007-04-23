Return-Path: <linux-kernel-owner+w=401wt.eu-S1161398AbXDWLNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161398AbXDWLNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161403AbXDWLNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:13:49 -0400
Received: from svr68.ehostpros.com ([67.15.48.48]:26398 "EHLO
	svr68.ehostpros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161398AbXDWLNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:13:48 -0400
Subject: Re: ChunkFS - measuring cross-chunk references
From: Kalpak Shah <kalpak@linsyssoft.com>
To: Karuna sagar K <karunasagark@gmail.com>
Cc: Amit Gud <gud@ksu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <2e4afe1e0704230019h3853bc82uae6c9b5cdc325ab9@mail.gmail.com>
References: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com>
	 <462B8D0C.7020509@ksu.edu>
	 <2e4afe1e0704230019h3853bc82uae6c9b5cdc325ab9@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 15:04:36 +0530
Message-Id: <1177320876.23226.7.camel@garfield>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - svr68.ehostpros.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linsyssoft.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 12:49 +0530, Karuna sagar K wrote:
> Hi,
> 
> The tool estimates the cross-chunk references from an extt2/3 file
> system. It considers a block group as one chunk and calcuates how many
> block groups does a file span across. So, the block group size gives
> the estimate of chunk size.
> 
> The file systems were aged for about 3-4 months on a developers laptop.
> 

With a blocksize of 4KB, a block group would be 128 MB. In the original
Chunkfs paper, Valh had mentioned 1GB chunks and I believe it will be
possible to use 2GB, 4GB or 8GB chunks in the future. As the chunk size
increases the number of cross-chunk references will reduce and hence it
might be a good idea to present these statistics considering different
chunk sizes starting from 512MB upto 2GB.

Thanks,
Kalpak.

