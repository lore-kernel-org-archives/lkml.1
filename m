Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZCKH5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZCKH5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 03:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZCKH5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 03:57:40 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:46202 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZCKH5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 03:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GM/7w/ljKSQVoiBrygZkYbgHF6EBNwU3KpAXTI4UokpgI/Lp5SLbhh5tO/XF+qUl38
         XOU84Tz17J2NAOxxpsIwBJLc2zXxACxNLFguZF5ybAwL2CS/FEtqECqXyHcN3lGSwgwV
         5EdwUg64wHAp9W1Q4qHaohnJAoK9hWy/X7tJc=
MIME-Version: 1.0
In-Reply-To: <1236756563-20633-1-git-send-email-graff.yang@gmail.com>
References: <1236756563-20633-1-git-send-email-graff.yang@gmail.com>
Date: Wed, 11 Mar 2009 03:57:37 -0400
Message-ID: <8bd0f97a0903110057x46cb2aa9p43dd8e12a28be67a@mail.gmail.com>
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
From: Mike Frysinger <vapier.adi@gmail.com>
To: graff.yang@gmail.com
Cc: samuel@sortiz.org, irda-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, graf.yang@analog.com, cooloney@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 03:29,  <graff.yang@gmail.com> wrote:
> +static int __devinit bfin_sir_probe(struct platform_device *pdev)
> +{
> +       struct net_device *dev;
> +       struct bfin_sir_self *self;
> +       unsigned int baudrate_mask;
> +       struct bfin_sir_port *sir_port;
> +       int err;
> +
> +       err = peripheral_request_list(per[pdev->id], DRIVER_NAME);

what if pdev->id is set to 12512 ?

> +       switch (max_rate) {
> +       default:
> +               printk(KERN_WARNING "bfin_sir: Invalid maximum baud rate, using 9600\n");

dev_warn(&dev->dev,....) ?
-mike
