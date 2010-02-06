Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab0BFA6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 19:58:16 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:27827 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab0BFA6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 19:58:15 -0500
Message-ID: <4B6CBE4B.703@oracle.com>
Date: Fri, 05 Feb 2010 16:56:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Ben Gardner <bgardner@wabtec.com>
Subject: Re: mmotm 2010-02-05-15-06 uploaded (pca953x)
References: <201002052332.o15NW0AO027963@imap1.linux-foundation.org>
In-Reply-To: <201002052332.o15NW0AO027963@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B6CBE9A.00B8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/10 15:06, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-02-05-15-06 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.33-rc6:


Should this driver depend on ARM?

drivers/gpio/pca953x.c:374: error: implicit declaration of function 'set_irq_flags'
drivers/gpio/pca953x.c:374: error: 'IRQF_VALID' undeclared (first use in this function)


These (function & macro) are only available in arch/arm/ AFAICT.


~Randy
