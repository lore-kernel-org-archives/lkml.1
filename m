Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab0CMTwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:52:30 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64993 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab0CMTw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:52:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QOU4M9HNFPjAC4FC94HPyHUiMx/xEkB3PDvfHkE/Y4/y5XeeXSxugYS47/gZEJ6dvX
         yWba1ne2PKtHsm4gOojMoy/G9j6H6sFwicgE5RTreyO5IPByTKvrfQ+weVWnDXIhgT+s
         UXeSvD29yr+dbWocuRGV2bllhfW2AHCE9fars=
MIME-Version: 1.0
Date: Sat, 13 Mar 2010 14:52:26 -0500
Message-ID: <b6bf7b051003131152t38c8b1e1m33e8844468b9e46a@mail.gmail.com>
Subject: Re: [PATCH] NET: tg3: fix brace, switch, and comma spacing coding 
	style in tg3.c This is a patch to the tg3.c file that aligns switch and case 
	statements, else statements following braces, and inserts a space after 
	commas listed in the coding style g
From: Steven Harms <thisdyingdream@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sjharms@gmail.com, mcarlson@broadcom.com, mchan@broadcom.com,
       benli@broadcom.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sharms@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Would you like me to submit the patch adding only the spaces after
commas and leave the rest of the defines as is, or discard the changes
all together?

On Sat, Mar 13, 2010 at 2:49 PM, David Miller <davem@davemloft.net> wrote:
> From: Steven Harms <sjharms@gmail.com>
> Date: Sat, 13 Mar 2010 14:39:11 -0500
>
>> -#define tw32_mailbox(reg, val)       tp->write32_mbox(tp, reg, val)
>> -#define tw32_mailbox_f(reg, val)     tw32_mailbox_flush(tp, (reg), (val))
>> -#define tw32_rx_mbox(reg, val)       tp->write32_rx_mbox(tp, reg, val)
>> -#define tw32_tx_mbox(reg, val)       tp->write32_tx_mbox(tp, reg, val)
>> -#define tr32_mailbox(reg)    tp->read32_mbox(tp, reg)
>> +#define tw32_mailbox(reg, val)       (tp->write32_mbox(tp, reg, val))
>
> Please keep this kind of code masterbation to yourself.
> This is not the style we want for this driver.
>



-- 
GPG Key ID: C92EF367 / 1428 FE8E 1E07 DDA8 EFD7 195F DCCD F5B3 C92E F367

WWW: http://www.sharms.org/blog
