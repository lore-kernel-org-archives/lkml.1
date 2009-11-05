Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbZKEKi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbZKEKi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 05:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZKEKi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 05:38:26 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:50844 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZKEKi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 05:38:26 -0500
Message-ID: <4AF2AB23.9000907@in.ibm.com>
Date: Thu, 05 Nov 2009 16:08:27 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: linux-next@vger.kernel.org, jbarnes@virtuousgeek.org, bjorn.helgaas@hp.com
Subject: Re: linux-next: Tree for November 5
References: <20091105190426.c9cadada.sfr@canb.auug.org.au>
In-Reply-To: <20091105190426.c9cadada.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next tree fails to build on i386 with

arch/x86/pci/built-in.o: In function `align_resource':
arch/x86/pci/acpi.c:82: undefined reference to `__udivdi3'

The code in question was added by commit
03db42adfeeabe856dbb6894dd3aaff55838330a.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

