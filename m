Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbXE3TVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbXE3TVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbXE3TVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:21:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:21034 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbXE3TVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:21:21 -0400
Message-ID: <465DCD9A.5030003@oracle.com>
Date: Wed, 30 May 2007 12:16:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: trivial@kernel.org, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [trivial PATCH, updated] fs: clarify "dummy" member in struct
 inodes_stat_t
References: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain> <20070529110041.49bf57f1.akpm@linux-foundation.org> <Pine.LNX.4.64.0705291406040.4617@localhost.localdomain> <20070529111902.27055fd0.randy.dunlap@oracle.com> <Pine.LNX.4.64.0705291416470.4736@localhost.localdomain> <465C71EA.5040706@oracle.com> <625fc13d0705291144u1aef3b6dx4b00873f3d05b652@mail.gmail.com> <20070529123326.a8a1bd64.randy.dunlap@oracle.com> <tkrat.2eccbb76ef1aee06@s5r6.in-berlin.de> <20070530112946.GT3899@stusta.de> <Pine.LNX.4.64.0705300733200.12382@localhost.localdomain> <tkrat.691ed5f2041a2996@s5r6.in-berlin.de>
In-Reply-To: <tkrat.691ed5f2041a2996@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> On 30 May, Robert P. J. Day wrote:
>> On Wed, 30 May 2007, Adrian Bunk wrote:
>>> Considering that we export this struct to usespace, I don't think
>>> renaming a member without a good reason is a good idea (but adding a
>>> comment makes sense).
> [...]
>> i thought i was submitting a fairly innocuous patch.  live and learn.
> 
> I've could have seen that it is defined outside #ifdef __KERNEL__.
> 
> 
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Subject: fs: clarify "dummy" member in struct inodes_stat_t

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> --- linux.orig/include/linux/fs.h
> +++ linux/include/linux/fs.h
> @@ -44,7 +44,7 @@ extern int get_max_files(void);
>  struct inodes_stat_t {
>  	int nr_inodes;
>  	int nr_unused;
> -	int dummy[5];
> +	int dummy[5];		/* padding for sysctl ABI compatibility */
>  };
>  extern struct inodes_stat_t inodes_stat;
>  
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
