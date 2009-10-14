Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbZJNTz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbZJNTz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbZJNTz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:55:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57058
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759161AbZJNTz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:55:58 -0400
Date: Wed, 14 Oct 2009 12:55:54 -0700 (PDT)
Message-Id: <20091014.125554.249768103.davem@davemloft.net>
To: jpiszcz@lucidpixels.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: What is eth"X"-Q0?
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0910141343240.23631@p34.internal.lan>
References: <alpine.DEB.2.00.0910141343240.23631@p34.internal.lan>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Piszcz <jpiszcz@lucidpixels.com>
Date: Wed, 14 Oct 2009 13:44:16 -0400 (EDT)

> On my new system, cat /proc/interrupts:
> 
>  36: 0 3055 2757 1086 1208446 25588 726447 1028280 PCI-MSI-edge eth2-Q0
>  37: 0 0 0 0 0 0 3 0 PCI-MSI-edge eth2
>  38: 0 103124 0 0 784 14511559 6936870 15972334 PCI-MSI-edge eth1-Q0
>  39: 0 0 0 0 2 0 0 0 PCI-MSI-edge eth1
> 
> What does the "-Q0" stand for, is this because the device was renamed?

It's for multiqueue.

Every queue in a multiqueue capable networking device will get a
different "ethX-QN" name for each queue's interrupt.
