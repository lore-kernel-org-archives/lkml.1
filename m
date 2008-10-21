Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYJUSPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYJUSPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYJUSPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:15:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:43515 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYJUSPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xGc9OCBzL9fjap17O5yI3oNmghlRROYXrgSraIbRvxlZ/Yl9eBFCZeOIf1A8wWye7E
         AdK6MMrr1y/H9kSA33HLFYbD6WOJN+jhjGMvLwJZR0mV6jj8Cl7UncOEfzcS+X8xZbAE
         y79lOj3QHCuVndnBt+a9yEJdacQpUklhuidA0=
Message-ID: <3aaafc130810211114p785cecabyb94d45096e6c65b5@mail.gmail.com>
Date: Tue, 21 Oct 2008 14:14:58 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: -git10 staging build warnings
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20081021180731.GA25571@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FE1459.5010205@oracle.com> <20081021180731.GA25571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 2:07 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Oct 21, 2008 at 10:41:45AM -0700, Randy Dunlap wrote:
>> i386:
>>
>> drivers/staging/sxg/sxg.c:462: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
>> drivers/staging/sxg/sxg.c:479: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
>> drivers/staging/sxg/sxg.c:540: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
>> drivers/staging/sxg/sxg.c:571: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'

Greg, does this have anything to do with the fix-gcc-warnings patch I
sent you a while back?

>>
>> x86_64:
>>
>> drivers/staging/winbond/./linux/wbusb .c:109: warning: 'struct ieee80211_tx_control' declared inside parameter list drivers/staging/winbond/./linux/wbusb.c:109: warning: its scope is only this definition or declaration, which is proba bly not what you want
>> drivers/staging/winbond/./linux/wbusb .c:172: warning: initialization from incompatible pointer type
>> drivers/staging/winbond/./linux/wbusb .c:174: warning: initialization from incompatible pointer type
>> drivers/staging/winbond/./linux/wbusb .c:180: warning: initialization from incompatible pointer type
>> drivers/staging/winbond/./linux/wbusb .c:181: warning: initialization from incompatible pointer type
>> drivers/staging/winbond/./linux/wbusb .c:299: warning: ISO C90 forbids mixed declarations and code
>> drivers/staging/usbip/vhci_rx.c:204: warning: format '%d' expects type 'int', but argument 7 has type 'long unsigned int'
>> drivers/staging/winbond/sme_api.c:13: warning: no return statement in function returning non-void
>
> Thanks, I have quite a few -staging patches queued up, need to ensure
> these get fixed as well.
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
