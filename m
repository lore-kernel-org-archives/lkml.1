Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbYIXSUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbYIXSUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYIXSUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:20:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:23118 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbYIXSUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wQZCShkoGHpUYN5ljZ4rkaCdTxxM/gT8UCJ0IuNxnv9qHeOuNmOB6sIE1D+W5QLjoO
         1mS/9Toh33jQ9/tNMkmLWI86TFwZ4R513q+5EFsOJ0aVJomv4UY96fK7Xe4KRGf5FA0X
         1oU+MkVOzmXmu2pAQGKcp7s8rsRPoO4W2YfaM=
Message-ID: <48DA84C9.3010707@gmail.com>
Date: Wed, 24 Sep 2008 20:19:53 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: suspend (uhci_hcd) defunct in mmotm 2008-09-13-03-09
References: <48DA64FC.4020706@gmail.com> <Pine.LNX.4.44L0.0809241229070.5963-100000@iolanthe.rowland.org> <20080924181403.GA6336@kroah.com>
In-Reply-To: <20080924181403.GA6336@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2008 08:14 PM, Greg KH wrote:
> On Wed, Sep 24, 2008 at 12:38:45PM -0400, Alan Stern wrote:
>> On Wed, 24 Sep 2008, Jiri Slaby wrote:
>>
>>>> In fact neither of those logs includes USB debugging messages.  Maybe
>>>> you omitted a mkinitrd step.
>>> I don't think so. I don't use neither vanilla nor initrd so this must be the
>>> kernel. Anyway I recompiled with .config linked in and did
>>> # dmesg >dmesg_config.hcd
>>> # zcat /proc/config.gz >>dmesg_config.hcd
>>> in the built kernel. The file is here:
>>> http://decibel.fi.muni.cz/~xslaby/dmesg_config.hcd
>> Still no debugging messages.  It's because you have 
>> CONFIG_DYNAMIC_PRINTK_DEBUG enabled.
> 
> If you have that enabled, you can turn on debugging "on the fly" by
> writing to the debugfs file as described in the documentation for that
> option.

I see, I need to boot to that kernel anyway, with dynamic_printk param this time.

Thanks.
