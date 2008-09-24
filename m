Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYIXQTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYIXQTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYIXQTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:19:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44247 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbYIXQTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:19:44 -0400
Message-ID: <48DA6887.1060709@zytor.com>
Date: Wed, 24 Sep 2008 09:19:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yan Li <elliot.li.tech@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>
In-Reply-To: <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Li wrote:
> Detects whether we are running as a VMware guest or not. Detection is
> based upon DMI vendor string.
> 
> It provides a function:
> int is_vmware_guest(void)
> that can be used easily to detect if we are running as a VMware guest
> or not.
> 
> I haven't used PCI vendor Id since that requires copying a trunk of
> codes from early_quirks() and I think copying code is not good. And
> reusing codes from early_quirks() needs intrivial change to present
> codes structure. Comparatively, checking "VMware" string against DMI
> manufacturer is a lot more simpler (one-line code). Also there's no
> evidence indicating that VMware will change their vendor string in
> near future. Therefore I choose to use simpler way.
> 
> Tested on x86 and x86-64 VMs and machines.

I'd like to make this a general VM platform detection subsystem.  We 
have similar issues with Virtual PC, and again, DMI appears to be the 
sanest way to detect it -- at least to a primary screen.

	-hpa
