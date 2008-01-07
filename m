Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYAGOK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYAGOK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 09:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYAGOKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 09:10:19 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:59617 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYAGOKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 09:10:18 -0500
Date: Mon, 7 Jan 2008 15:10:15 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080107141014.GA12763@boogie.lpds.sztaki.hu>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080103131620.GA16307@boogie.lpds.sztaki.hu> <20080104010542.GA2860@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104010542.GA2860@darkstar.te-china.tietoenator.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 04, 2008 at 09:05:42AM +0800, Dave Young wrote:

> Could you try the patch (on 2.6.24-rc6) following and check the debug messages? 
> 
> diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
> --- linux/net/bluetooth/rfcomm/tty.c	2008-01-04 08:58:48.000000000 +0800
> +++ linux.new/net/bluetooth/rfcomm/tty.c	2008-01-04 09:01:01.000000000 +0800
> @@ -313,6 +313,7 @@ static void rfcomm_dev_del(struct rfcomm
>  {
>  	BT_DBG("dev %p", dev);
>  
> +	dump_stack();
>  	set_bit(RFCOMM_TTY_RELEASED, &dev->flags);
>  	rfcomm_dev_put(dev);
>  }

This did not trigger.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
