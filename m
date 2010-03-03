Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0CCSmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:42:36 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37794 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0CCSme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:42:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NmAVxu3YK+da6fmGbYLucW+KtOzz7N9zqmlHYs3a3WvaUd0DYdbuGErYhI5MJnr6bd
         TqwumpAUk79LKJLBfyKFvVv8ROPsc5zb7+L9XiX3QNnbiRMrWDbc8t386JNHNXaqEMPo
         hH9nC40+JQOudASv8O4QZ0oF5nWqJEM5kWXKo=
Date: Wed, 3 Mar 2010 21:42:28 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] ahci: Export generic AHCI symbols, turn libahci
 into a separate module
Message-ID: <20100303184228.GA3492@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
 <20100303171749.GJ12362@oksana.dev.rtsoft.ru>
 <4B8EA21A.2040601@ru.mvista.com>
 <20100303180834.GA11184@oksana.dev.rtsoft.ru>
 <20100303181402.GA22792@oksana.dev.rtsoft.ru>
 <4B8EAB99.5080804@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B8EAB99.5080804@pobox.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 01:34:01PM -0500, Jeff Garzik wrote:
[...]
> >OTOH, we can introduce invisible SATA_LIBAHCI, which is better,
> >I think.
> 
> There is no need for any Kconfig wrangling.  Just do it in the Makefile:
> 
> obj-$(SATA_AHCI_EXAMPLE1) += sata_example1.o libahci.o
> obj-$(SATA_AHCI_EXAMPLE2) += sata_example2.o libahci.o
> 
> Thus,
> 
> 1) update PCI ahci's Makefile entry
> 2) add Kconfig and Makefile entry for platform_ahci
> 
> No need to touch PCI AHCI's Kconfig bits at all.

Ah, I see. Will do.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
