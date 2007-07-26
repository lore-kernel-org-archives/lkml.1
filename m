Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbXGZBzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbXGZBzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXGZBzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:55:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:27740 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbXGZBzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nYE8bRx/41VyyycYwK/SjPdxVMbUOOq8ulwhSz5K+7s0iGMkMTysaP7C6bpraY4v3Tk4Loy4YRbyweVEEM8m/8ndn5d32sz3ewmiDvs2/Vw3WsK0GvB8ReVXPP1gGwOZfKc1M4kdmy/2afhEQkeHGv8fXevWduivIezeRcHmkG8=
Message-ID: <a8e1da0707251855u5a0a3458rfc11ac6cf649cd68@mail.gmail.com>
Date: Thu, 26 Jul 2007 01:55:03 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc1-mm1
Cc: "Greg KH" <gregkh@suse.de>, "Gabriel C" <nix.or.die@googlemail.com>,
       "Dave Hansen" <haveblue@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
In-Reply-To: <20070725172845.8dec8ec5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	 <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com>
	 <20070725185328.GA28199@uranus.ravnborg.org>
	 <46A7A1EF.8060307@zytor.com> <46A7B983.90407@googlemail.com>
	 <46A7BB12.7060504@googlemail.com> <20070726000705.GB21056@suse.de>
	 <20070725172845.8dec8ec5.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
drivers/built-in.o(.text+0xc649): In function `acpi_pci_choose_state':
: undefined reference to `acpi_pm_device_sleep_state'
drivers/built-in.o(.text+0x3fe08): In function `pnpacpi_suspend':
: undefined reference to `acpi_pm_device_sleep_state'
make: *** [.tmp_vmlinux1] Error 1

The pci-acpi.c depends on CONFIG_ACPI_SLEEP
