Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbXCRQRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbXCRQRF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 12:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbXCRQRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 12:17:05 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34223 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752267AbXCRQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 12:17:04 -0400
Date: Sun, 18 Mar 2007 17:17:07 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ismail =?utf-8?Q?D=C3=B6nmez?= <ismail@pardus.org.tr>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [BUG] While rmmod ohci1394
Message-ID: <20070318161707.GR752@stusta.de>
References: <45FD616C.30909@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45FD616C.30909@m3y3r.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 04:57:32PM +0100, Thomas Meyer wrote:
> This happens with cd05a1f818073a623455a58e756c5b419fc98db9:
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address
> 000000a4
>  printing eip:
> c021ca33
> *pde = 00000000
> Oops: 0000 [#1]
> SMP
>...
> Call Trace:
>  [<c021cb13>] class_device_del+0xba/0xe8
>  [<f933d9fb>] __nodemgr_remove_host_dev+0x0/0xb [ieee1394]
>...
> EIP: [<c021ca33>] class_device_remove_attrs+0xa/0x30 SS:ESP 0068:ee3ebe3

Known regression:

Subject    : Oops in __nodemgr_remove_host_dev
References : http://lkml.org/lkml/2007/3/14/4
Submitter  : Ismail Dönmez <ismail@pardus.org.tr>
             Stefan Richter <stefanr@s5r6.in-berlin.de>
Caused-By  : Greg Kroah-Hartman <gregkh@suse.de>
             commit 43cb76d91ee85f579a69d42bc8efc08bac560278
             commit 40cf67c5fcc513406558c01b91129280208e57bf
Handled-By : Stefan Richter <stefanr@s5r6.in-berlin.de>
Status     : problem is being debugged


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

