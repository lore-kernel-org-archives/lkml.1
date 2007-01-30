Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbXA3XJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbXA3XJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXA3XJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:09:17 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51533 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbXA3XJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:09:16 -0500
Message-ID: <45BFD016.5050302@us.ibm.com>
Date: Tue, 30 Jan 2007 17:09:10 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for	profiling
 Cell BE SPUs -- update
References: <45BE4ED0.5030808@us.ibm.com> <45BE4FA4.9020105@us.ibm.com> <200701300839.05144.arnd@arndb.de> <1170143630.26655.326.camel@localhost.localdomain> <20070130104120.GB14571@lst.de>
In-Reply-To: <20070130104120.GB14571@lst.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:

> On Tue, Jan 30, 2007 at 06:53:50PM +1100, Benjamin Herrenschmidt wrote:
> 
>>>>+/* Defines used for sync_start */
>>>>+#define SKIP_GENERIC_SYNC 0
>>>>+#define SYNC_START_ERROR -1
>>>>+#define DO_GENERIC_SYNC 1
>>>>+
>>>>+typedef struct vma_map
>>>>+{
>>>>+       struct vma_map *next;
>>>>+       unsigned int vma;
>>>>+       unsigned int size;
>>>>+       unsigned int offset;
>>>>+       unsigned int guard_ptr;
>>>>+       unsigned int guard_val;
>>>>+} vma_map_t;
>>
>>I haven't had time to look in details yet but in that context, what does
>>"vma" stands for ? There's already an important vm data structure in
>>linux routinely called "vma" and thus I suspect this is a poor naming
>>choice as it will cause confusion.
> 
> 
> It looks like it actually is dealing with vma to me.  But then again:
> 
>  - please don't use typedefs for structures
>  - there might be a more descriptive name for this than just vma_map
Yes, I'll come up with some (hopefully) better name.
> 
> -------------------------------------------------------------------------
> Take Surveys. Earn Cash. Influence the Future of IT
> Join SourceForge.net's Techsay panel and you'll get the chance to share your
> opinions on IT & business topics through brief surveys - and earn cash
> http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
> _______________________________________________
> oprofile-list mailing list
> oprofile-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/oprofile-list


