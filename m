Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbXDZJMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbXDZJMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933699AbXDZJMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:12:37 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4748 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652AbXDZJMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:12:36 -0400
Date: Thu, 26 Apr 2007 10:12:22 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
Subject: Re: pcmcia - failed to initialize IDE interface
Message-ID: <20070426091222.GA16723@flint.arm.linux.org.uk>
Mail-Followup-To: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
References: <20070425190753.fb8c272d.akpm@linux-foundation.org> <D7810733513F4840B4EBAAFA64D9C6A4012D6148@stgw002a.ww002.siemens.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D7810733513F4840B4EBAAFA64D9C6A4012D6148@stgw002a.ww002.siemens.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 10:48:09AM +0200, Aeschbacher, Fabrice wrote:
> __request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
> __request_resource: new=ide0[102000-102007], root=PCI IO[1000-fffffffff]
> 
> I added some printk() only for debugging raisons (for example in
> __request_resource, as you can see)

You might want to also dump the resource flags as well.  The two I show
above (from the PCMCIA calls in ide_config) should not mark the resources
busy.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
