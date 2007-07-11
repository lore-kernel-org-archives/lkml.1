Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXGKSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXGKSwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765868AbXGKSwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:52:00 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:65227 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765691AbXGKSv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:51:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=txKcodme0CalabhWvntaRndJMf1NESu8j1KnMkRgRUfm9GAuFceWA8fjfK/0hpgiFSkWxztorlrRADu3W8PZP7Te2L6F5Xzxe+Bhbo5c244AzJsmSJZ3ofRmtV7IrwXpybRvv+d2jHMh57TgW5XsHQc2fOf7NgnSK+sNai2pmwM=
Message-ID: <6278d2220707111151o2b5f8b23ha14bf77be71b8b61@mail.gmail.com>
Date: Wed, 11 Jul 2007 19:51:55 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: [2.6.22-rc7] khubd NULL deref oops...
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <46950D94.7050909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220707081445s6c5029a6la5ae0fd019176f74@mail.gmail.com>
	 <46950D94.7050909@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> On 07/08/2007 05:45 PM, Daniel J Blueman wrote:
> > When plugging in a USB 2 mass-storage device which I've been seeing
> > problems with, I caught a khubd oops [1]. Kernel is 2.6.22-rc7 on ia32
> > built with Ubuntu's 2.6.22 .config.
>
> > [ 4769.252000] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> > [ 4769.252000]  sdb: sdb1 < sdb5 sdb6<6>usb 5-3: reset high speed USB
> > device using ehci_hcd and address 8
>
> So the device got reset right in the middle of scanning for partitions.
>
> > [ 4769.544000] usb 5-3: device descriptor read/64, error -71
> > [ 4769.760000] usb 5-3: device descriptor read/64, error -71
> > [ 4769.976000] usb 5-3: reset high speed USB device using ehci_hcd and
> > address 8
> > [ 4770.088000] usb 5-3: device descriptor read/64, error -71
> > [ 4770.304000] usb 5-3: device descriptor read/64, error -71
> > [ 4770.520000] usb 5-3: reset high speed USB device using ehci_hcd and
> > address 8
> > [ 4770.928000] usb 5-3: device not accepting address 8, error -71
> > [ 4771.040000] usb 5-3: reset high speed USB device using ehci_hcd and
> > address 8
>
> Then a whole slew of these by-now-familiar messages.
>
> Try disabling CONFIG_USB_SUSPEND.  It makes lots of USB bugs go away

I'll give it a shot. For the record, I wasn't trying to perform a
suspend at this time (or since booting).

Thanks for your help,
  Daniel
-- 
Daniel J Blueman
