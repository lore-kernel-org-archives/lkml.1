Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753197AbYLQTnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYLQTnq (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYLQTnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:43:19 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:40797 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYLQTnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:43:17 -0500
Date: Wed, 17 Dec 2008 11:43:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        sameo@openedhand.com
Subject: Re: linux-next: Tree for December 15 (mfd)
Message-Id: <20081217114300.9476f8da.randy.dunlap@oracle.com>
In-Reply-To: <4946AF6A.8030107@oracle.com>
References: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
	<4946AF6A.8030107@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49495648.0200:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008 11:26:34 -0800 Randy Dunlap wrote:

> Lots of mfd build failures like this:
> 
> 
> build-r7123.out:/local/linsrc/linux-next-20081215/drivers/mfd/twl4030-irq.c:183: error: 'irq_desc' undeclared (first use in this function)
> build-r7123.out:/local/linsrc/linux-next-20081215/drivers/mfd/twl4030-irq.c:455: error: 'irq_desc' undeclared (first use in this function)
> build-r7123.out:/local/linsrc/linux-next-20081215/drivers/mfd/twl4030-irq.c:515: error: 'irq_desc' undeclared (first use in this function)
> build-r7123.out:make[3]: *** [drivers/mfd/twl4030-irq.o] Error 1


This build error still happens in linux-next-20081217.

It only occurs when I2C=y (see drivers/mfd/Kconfig).

Stephen, doing an allyesconfig i386 or x86_64 build will catch this,
then you can drop the mfd tree and hopefully prod someone into fixing this...

---
~Randy
