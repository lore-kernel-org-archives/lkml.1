Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZDOUjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZDOUjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZDOUix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:38:53 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:45348 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbZDOUix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:38:53 -0400
Message-ID: <49E645CD.3080101@oracle.com>
Date: Wed, 15 Apr 2009 13:38:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, den@openvz.org
Subject: Re: mmotm 2009-04-14-17-24 uploaded (mtd)
References: <200904150024.n3F0Ovdo019569@imap1.linux-foundation.org>	<49E5FFB8.2020906@oracle.com> <20090415132746.e45d8fd9.akpm@linux-foundation.org>
In-Reply-To: <20090415132746.e45d8fd9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49E645A9.00E5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 15 Apr 2009 08:39:36 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2009-04-14-17-24 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://git.zen-sources.org/zen/mmotm.git
>>>
>>> It contains the following patches against 2.6.30-rc1:
>>
>>
>> drivers/mtd/mtdcore.c:51: error: invalid operands to binary *
> 
> hrm.  This, I suppose:

Yes, that builds cleanly.  Thanks.

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> --- a/drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix
> +++ a/drivers/mtd/mtdcore.c
> @@ -48,7 +48,7 @@ static LIST_HEAD(mtd_notifiers);
>   */
>  static void mtd_release(struct device *dev)
>  {
> -	dev_t index = MTD_DEVT(dev_to_mtd(dev));
> +	dev_t index = MTD_DEVT(dev_to_mtd(dev)->index);
>  
>  	/* remove /dev/mtdXro node if needed */
>  	if (index)
> _
> 


-- 
~Randy
