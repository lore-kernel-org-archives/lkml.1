Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbZENU5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbZENU5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZENU53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:57:29 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:50688 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZENU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:57:28 -0400
Message-ID: <4A0C8631.7090106@oracle.com>
Date: Thu, 14 May 2009 13:59:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TRIVIAL: fix grammo in bus_for_each_dev() kerneldoc
References: <20090514144339.18912.65431.stgit@bob.kio>
In-Reply-To: <20090514144339.18912.65431.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A0C85B0.021B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Cc: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/base/bus.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index dc030f1..4476a4e 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -279,7 +279,7 @@ static struct device *next_device(struct klist_iter *i)
>   *
>   * NOTE: The device that returns a non-zero value is not retained
>   * in any way, nor is its refcount incremented. If the caller needs
> - * to retain this data, it should do, and increment the reference
> + * to retain this data, it should do so, and increment the reference
>   * count in the supplied callback.
>   */
>  int bus_for_each_dev(struct bus_type *bus, struct device *start,
> 


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
