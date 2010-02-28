Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032075Ab0B1VLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 16:11:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:46808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032059Ab0B1VLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 16:11:44 -0500
References: <20100226093957.7b99d09c@jbarnes-piketon> <alpine.LFD.2.00.1002281227300.3851@localhost.localdomain> <alpine.LFD.2.00.1002281246120.3637@localhost.localdomain>
Message-Id: <33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org>
From: Yinghai <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1002281246120.3637@localhost.localdomain>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [git pull] PCI changes for 2.6.34
Date: Sun, 28 Feb 2010 13:11:20 -0800
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Feb 28, 2010, at 12:46 PM, Linus Torvalds <torvalds@linux-foundation.org 
 > wrote:

>
>
> On Sun, 28 Feb 2010, Linus Torvalds wrote:
>>
>> I just bisected a Nouveau boot failure to commit 977d17bb17 ("PCI:  
>> update
>> bridge resources to get more big ranges in PCI assign unssigned"),  
>> and I'm
>> going to revert that today one unless I can get a patch that fixes  
>> it for
>> me.
>
> Btw, it's not just bisected, I also verified that a revert on top of  
> the
> current git tree does fix it for me.

Sorry for that

Maybe we need to put back pci=try=num back
And set pci_try_num=1 by default

Yinghai
