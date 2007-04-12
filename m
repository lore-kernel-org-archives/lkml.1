Return-Path: <linux-kernel-owner+w=401wt.eu-S1030775AbXDLVaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030775AbXDLVaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030776AbXDLVaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:30:20 -0400
Received: from dsl-mtryl-66-18-218-115-cgy.nucleus.com ([66.18.218.115]:57055
	"HELO schaus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030775AbXDLVaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:30:19 -0400
Message-ID: <461EA4EA.2020208@schaus.ca>
Date: Thu, 12 Apr 2007 15:30:18 -0600
From: Cameron Schaus <cam@schaus.ca>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 OOM with 8Gb RAM
References: <20070412173830.GA31323@schaus.ca> <20070412121553.c7fd3249.akpm@linux-foundation.org>
In-Reply-To: <20070412121553.c7fd3249.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> All of ZONE_NORMAL got used by ramdisk, and networking wants to
> allocate a page from ZONE_NORMAL.  An oom-killing is the correct
> response, although probably not effective.
>
> ramdisk is a nasty thing - cannot you use ramfs or tmpfs?
>   
Sure enough, changing the ramdisk to a tmpfs did the trick.  No more OOM 
(at least for now).

Thanks!
Cam


