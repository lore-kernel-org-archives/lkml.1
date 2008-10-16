Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYJPUDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYJPUDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 16:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYJPUDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 16:03:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:47653 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYJPUDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 16:03:21 -0400
Date: Thu, 16 Oct 2008 13:02:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, akpm@linux-foundation.org,
       dan.j.williams@intel.com, tiwai@suse.de, linux-ext4@vger.kernel.org,
       netdev@vger.kernel.org, linux-ide@vger.kernel.org, bzolnier@gmail.com,
       marek.vasut@gmail.com, dwmw2@infradead.org, mark.fasheh@oracle.com,
       ralf@linux-mips.org, mchehab@infradead.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: powerpc allmodconfig
Message-ID: <20081016130237.4984967c@infradead.org>
In-Reply-To: <20081016.124923.222595655.davem@davemloft.net>
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
	<20081015.220247.262683261.davem@davemloft.net>
	<1224169039.735.57.camel@johannes.berg>
	<20081016.124923.222595655.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 12:49:23 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:
> #endif
> #define __WARN() warn_on_slowpath(__FILE__, __LINE__)
> #define __WARN_printf(arg...) warn_slowpath(__FILE__, __LINE__, arg)
> #else
> #define __WARN_printf(arg...) __WARN()

the easiest way I suppose would be to do

#define __WARN_printf(arg..) do { printk(arg); __WARN(); } while (0)

any obvious problems with this ?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
