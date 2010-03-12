Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0CLCdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 21:33:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:37860 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab0CLCdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 21:33:23 -0500
Message-ID: <4B99A7B9.3000802@kernel.org>
Date: Thu, 11 Mar 2010 18:32:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland Dreier <rdreier@cisco.com>
CC: Alexander Beregalov <a.beregalov@gmail.com>, Greg KH <gregkh@suse.de>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34-rc1: ACPI: BUG: key f71f0168 not in .data!
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>	<86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>	<m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org> <m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org>
In-Reply-To: <4B99A6F0.4080203@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 06:29 PM, Yinghai Lu wrote:
> 
> 
> have some typo in your patch.. all have the same name....
> 
> change them to right name, will fix that in ipmi path...

still need this one for inifiniband.

---
 drivers/infiniband/core/sysfs.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/infiniband/core/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/core/sysfs.c
+++ linux-2.6/drivers/infiniband/core/sysfs.c
@@ -461,6 +461,7 @@ alloc_group_attrs(ssize_t (*show)(struct
 		element->attr.attr.mode  = S_IRUGO;
 		element->attr.show       = show;
 		element->index		 = i;
+		sysfs_attr_init(&element->attr.attr);
 
 		tab_attr[i] = &element->attr.attr;
 	}
