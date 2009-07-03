Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZGCBl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZGCBl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZGCBlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:41:19 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:43925 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZGCBlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:41:18 -0400
Message-ID: <4A4D61BE.2010807@oss.ntt.co.jp>
Date: Fri, 03 Jul 2009 10:41:18 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/vt6655: pointer to driver_data needs to be type
 long
References: <4A442E7C.7070301@oss.ntt.co.jp> <20090702194952.GF10957@kroah.com>
In-Reply-To: <20090702194952.GF10957@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Jun 26, 2009 at 11:12:12AM +0900, Fernando Luis Vázquez Cao wrote:
>> Fix the compilation error below while at it.
>>
>> drivers/staging/vt6655/device_main.c:347: warning: cast from pointer to integer of different size
>> drivers/staging/vt6655/device_main.c:347: error: initializer element is not constant
>> drivers/staging/vt6655/device_main.c:347: error: (near initialization for ‘device_id_table[0].driver_data’)
>>
>> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> 
> This patch doesn't apply :(
> 
> Care to resync off of tomorrow's linux-next tree?

It seems that a patch from Alan Cox (linux-next: 38d257422fb010e11180fc9c5794812f390aca74)
which fixes this issue got merged first, so mine is not needed anymore if you are planning
to send the fix to Linus before the next merge window. What are your plans?

Thanks,

Fernando
