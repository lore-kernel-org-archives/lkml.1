Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbZASWnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbZASWnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZASWmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:42:52 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:35728 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751759AbZASWmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:42:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DFzizVUjUvfgL7ieuM9FLqRMaLwdqRbQyWBUR0Yvr90pXH7NXO5acdZK8fYzqA5x+8tdj2SyTfwY0tOLbgPyCM/3ShDgFiCoNzT4W3H+EfUkOHg5JazoYou2XeI9cISWZg2yXrazpqpuKe5zWhpHw29aAYfPAn1r8qapMikaWek=  ;
X-YMail-OSG: LmqYalkVM1n4vCzi8Uq0W60B7Ti6aZc9r5Mdysk.ijPnSkJ0Brsw4x_DRTvjIqj8lCQp4VJu2a_VBvS5pDvPj4DK1ZBOffWHRzpuJKAWvzpotojZJFb3_g.6CA2yO64Ykz3_onNi_E2v8spjhs8ymZSl
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/6] omap iommu: tlb and pagetable primitives
Date: Mon, 19 Jan 2009 14:42:49 -0800
User-Agent: KMail/1.9.10
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
References: <20090116083709.18344.74524.stgit@oreo.research.nokia.com> <20090119.114407.177399457.Hiroshi.DOYU@nokia.com> <20090119215858.GA31848@n2100.arm.linux.org.uk>
In-Reply-To: <20090119215858.GA31848@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191442.49561.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Russell King - ARM Linux wrote:
> 
> > > Use dev_vdbg() to get the "NOP unless VERBOSE is set" semantics.
> > 
> > Thanks. This is what I wanted... I'll update with "dev_vdbg()".
> 
> Sorry, drop the 'v' in that (typo).

Not clear what that comment means ... dev_vdbg() is the same as
dev_dbg() *IF* the VERBOSE option is set, and is otherwise a NOP.

That is:  two levels of debug messaging, for use as needed.
As a rule, some Kconfig option will

  ccflags-$(CONFIG_DEBUG_whatever)    += -DDEBUG

to enable DEBUG for that subsystem, and the VERBOSE option
(see <linux/device.h>) is set selectively by hand.

- Dave
