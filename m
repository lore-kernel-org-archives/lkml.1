Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYICDvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYICDvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 23:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbYICDvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 23:51:43 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:16741 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbYICDvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 23:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=p4ktrKKhEye0OPTaGQzVmLJPrghM/LaZ/kICk5PpPdesXYAemLOBaomnTwQZ8tDzOx
         4kmwJ0StWrMolvPh+7ZO5NNhARYJZgGTAb81INttKI6O8fuySZd8HrvHM5F7AGpRkZ3E
         66UMZJyyXkU9EXKA8mMdMh11nS8aiZL4c/l5o=
Message-ID: <2a27d3730809022051p73cdfe92sde02996c6f22db9b@mail.gmail.com>
Date: Wed, 3 Sep 2008 11:51:39 +0800
From: "Li Yang" <leoli@freescale.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH v3] usb: add Freescale QE/CPM USB peripheral controller driver
Cc: greg@kroah.com, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       avorontsov@ru.mvista.com
In-Reply-To: <200809021401.25506.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220356690-8028-1-git-send-email-leoli@freescale.com>
	 <200809021401.25506.arnd@arndb.de>
X-Google-Sender-Auth: 9e4cb44f63684d8b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2008 at 8:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 02 September 2008, Li Yang wrote:
>> Some of Freescale SoC chips have a QE or CPM co-processor which
>> supports full speed USB.  The driver adds device mode support
>> of both QE and CPM USB controller to Linux USB gadget.  The
>> driver is tested with MPC8360 and MPC8272, and should work with
>> other models having QE/CPM given minor tweaks.
>>
>> Signed-off-by: Xie Xiaobo <X.Xie@freescale.com>
>> Signed-off-by: Li Yang <leoli@freescale.com>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> All my previous review comments have been addressed.
>
>> +     udc_controller->soc_type = (unsigned long)np->data;
>
> I'm not sure about this line, shouldn't that be
>        udc_controller->soc_type = (unsigned long)match->data; ?

Oops.  You are right.

- Leo
