Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZCKJ5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZCKJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 05:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZCKJ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 05:57:00 -0400
Received: from mail-gx0-f167.google.com ([209.85.217.167]:61169 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZCKJ47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 05:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ealOr1blSRKKwTBMht8AEpWZbOc6FzbNB0YOippZRy195XF0PefwAeMpPk2qtNbLHU
         6ytuHM+zg+8a3EJ72T4UdxJE1FLnrWsWpA2VfLcxLW9ZGjbq/iAWs7qe9/nP2pPawbVr
         amdeR8QZmfCc2s2Wnpa/fq3cA0s38QJ1Z4XLg=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0903110057x46cb2aa9p43dd8e12a28be67a@mail.gmail.com>
References: <1236756563-20633-1-git-send-email-graff.yang@gmail.com>
	 <8bd0f97a0903110057x46cb2aa9p43dd8e12a28be67a@mail.gmail.com>
Date: Wed, 11 Mar 2009 17:56:56 +0800
Message-ID: <7d86d44a0903110256t11edeff5qfd21055ef047dc2a@mail.gmail.com>
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
From: graff yang <graff.yang@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: samuel@sortiz.org, irda-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, graf.yang@analog.com, cooloney@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 3:57 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Mar 11, 2009 at 03:29,  <graff.yang@gmail.com> wrote:
>> +static int __devinit bfin_sir_probe(struct platform_device *pdev)
>> +{
>> +       struct net_device *dev;
>> +       struct bfin_sir_self *self;
>> +       unsigned int baudrate_mask;
>> +       struct bfin_sir_port *sir_port;
>> +       int err;
>> +
>> +       err = peripheral_request_list(per[pdev->id], DRIVER_NAME);
>
> what if pdev->id is set to 12512 ?

The pdev->id is defined in board files, for example, uart0 should be 0.
>
>> +       switch (max_rate) {
>> +       default:
>> +               printk(KERN_WARNING "bfin_sir: Invalid maximum baud rate, using 9600\n");
>
> dev_warn(&dev->dev,....) ?

Here the netdev has not been registered.

> -mike
>



-- 
-Graff
