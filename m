Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZKEQbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZKEQbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZKEQbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:31:02 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:43984 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262AbZKEQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:31:00 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: linux-next: Tree for November 5
Date: Thu, 5 Nov 2009 10:31:04 -0600
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       jbarnes@virtuousgeek.org
References: <20091105190426.c9cadada.sfr@canb.auug.org.au> <4AF2AB23.9000907@in.ibm.com>
In-Reply-To: <4AF2AB23.9000907@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911050931.04838.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 November 2009 03:38:27 am Sachin Sant wrote:
> Today's next tree fails to build on i386 with
> 
> arch/x86/pci/built-in.o: In function `align_resource':
> arch/x86/pci/acpi.c:82: undefined reference to `__udivdi3'
> 
> The code in question was added by commit
> 03db42adfeeabe856dbb6894dd3aaff55838330a.

I'll look into this.  I did build and test a 32-bit x86 kernel, but
I built it on an x86_64 box using "linux32 make ...", which looks like
it used gcc 4.3.2.

Bjorn
