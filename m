Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYHUQze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYHUQze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYHUQzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:55:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:4620 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYHUQzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=dRVHDD1slQ4rEQqYkJtkMbylXfbebfbvPtw+pba2U/ly1KC254uMQlPAp9pJqIKAlg
         6HL+NBU/5y9TQ4G0+fwIgCP6SUtZvCs9254ElxaA9wQQLM4m9kZbju9zkzwFniIhsHSe
         bmQM3TP9VI7w6p6lWyy69NugYVqajJ8F4oFBk=
Date: Thu, 21 Aug 2008 20:56:48 +0400
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: hwclock problems still present in 2.6.27-rc4
Message-ID: <20080821165648.GA2732@x200.localdomain>
References: <20080821163920.GA19140@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821163920.GA19140@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: adobriyan@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 06:39:20PM +0200, Norbert Preining wrote:
> I have read through quite some threads on lkml and bug reports regarding
> the hangs/freezes of the kernel when hwclock is called.
> 
> I still see that behaviour on 2.6.27-rc4 with
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> CONFIG_RTC_DRV_CMOS=y
> (all rtc and hpet related config vars).

> What is the recommended way to fix that, or do you need some more
> information?

Remove CONFIG_RTC_* options for start. Unless you knowingly selected
them, of course.

