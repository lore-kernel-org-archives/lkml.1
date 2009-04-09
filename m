Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbZDIJtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbZDIJtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762821AbZDIJtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:49:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51933 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759172AbZDIJtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:49:11 -0400
Date: Thu, 9 Apr 2009 10:49:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: fangxiaozhi 00110321 <huananhu@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       greg@kroah.com
Subject: Re: The problems for driver module loading
Message-ID: <20090409104930.59485167@lxorguk.ukuu.org.uk>
In-Reply-To: <fad7ab4fac82c.ac82cfad7ab4f@huawei.com>
References: <fad7ab4fac82c.ac82cfad7ab4f@huawei.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    Because cdc_ether.ko driver can not support our QMI protocol, so we want the Linux system can always attach our driver to our device, but not cdc_ether.ko driver.
> 
>    How can I do for this? 

The easiest way is probably to submit some changes to cdc_ether to add
QMI support, or when submitting the QMI driver to also submit a patch to
cdc_ether to make it leave the device alone.

That doesn't help with exising systems however. What do the descriptors
for the hardware look like as cdc_* do actually try to avoid vendor
specific modem intefaces ?

Alan
