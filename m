Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab0BKCpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 21:45:34 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:63084 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab0BKCpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 21:45:32 -0500
Message-ID: <4B736ED5.5060205@oracle.com>
Date: Wed, 10 Feb 2010 18:43:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Mocean Laboratories <info@mocean-labs.com>
Subject: Re: mmotm 2010-02-10-16-17 uploaded (timberdale)
References: <201002110043.o1B0hKxW008835@imap1.linux-foundation.org>
In-Reply-To: <201002110043.o1B0hKxW008835@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B736F3F.00DA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/10 16:17, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-02-10-16-17 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.33-rc7:


When CONFIG_GPIOLIB is not enabled:

  CC      drivers/mfd/timberdale.o
In file included from mmotm-2010-0210-1617/drivers/mfd/timberdale.c:37:
mmotm-2010-0210-1617/include/linux/spi/max7301.h:14: error: field 'chip' has incomplete type
make[3]: *** [drivers/mfd/timberdale.o] Error 1


Build error observed on i386 and on x86_64.

-- 
~Randy
