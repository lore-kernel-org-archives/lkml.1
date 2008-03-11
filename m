Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYCKSUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYCKSUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYCKSTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:19:53 -0400
Received: from gw.goop.org ([64.81.55.164]:50936 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbYCKSTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:19:52 -0400
Message-ID: <47D6CD04.8060303@goop.org>
Date: Tue, 11 Mar 2008 11:18:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: 2.6.25-rc5-mm1 (paravirt/vsmp/no PCI)
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <20080311100955.ca113f90.randy.dunlap@oracle.com>
In-Reply-To: <20080311100955.ca113f90.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:

Added Cc:

> On Tue, 11 Mar 2008 01:14:34 -0700 Andrew Morton wrote:
>
>   
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
>>     
>
> randconfig (x86_64) with
> PCI=n
> PARAVIRT=y
> VSMP=n
>
> ends with
>
> arch/x86/kernel/built-in.o: In function `is_vsmp_box':
> (.text+0x1178d): undefined reference to `early_pci_allowed'
> arch/x86/kernel/built-in.o: In function `is_vsmp_box':
> (.text+0x117a9): undefined reference to `read_pci_config'
> arch/x86/kernel/built-in.o: In function `vsmp_init':
> (.init.text+0x4fcc): undefined reference to `early_pci_allowed'
> arch/x86/kernel/built-in.o: In function `vsmp_init':
> (.init.text+0x501a): undefined reference to `read_pci_config'
> make[1]: *** [.tmp_vmlinux1] Error 1
>
> config attached.

    J
