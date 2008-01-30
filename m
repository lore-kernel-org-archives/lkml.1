Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYA3KBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYA3KBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYA3KBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:01:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:37254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbYA3KBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:01:08 -0500
From: Andi Kleen <ak@suse.de>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: ioremap_xxx() with EXEC enabled
Date: Wed, 30 Jan 2008 10:59:39 +0100
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1201685530.17912.11.camel@caritas-dev.intel.com>
In-Reply-To: <1201685530.17912.11.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801301059.40568.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008 10:32, Huang, Ying wrote:
> Hi,
>
> On i386, EFI may need to map EFI runtime code area as EXEC enabled with
> ioremap(). But, I found that the memory are mapped as EXEC disabled when
> mapped with ioremap() now. I think we may need a method to map memory
> area as EXEC enabled with ioremap_xxx(). Some possible interface schemes
> for mapping as EXEC enabled are as follow:

Does __ioremap(..., PAGE_KERNEL_EXEC) not work?

-Andi
