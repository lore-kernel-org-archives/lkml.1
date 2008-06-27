Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbYF0PKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbYF0PKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYF0PKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:10:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:4342 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYF0PKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=rmvajScQ7BqrdropetJCTj9GEpEgovy5f9q1bzmOVuQRFMfRiT9AOzGqjE9CtzP29L
         yQCIxZ8y59W6wdePuaFGrUbloj7ZlwVY4Ve6Nkx4wK1mlyhJeW6D8X+DaxtINBOZ83OZ
         WNc6mM6IzjsFWDKifYTDfiaETPM3K+WQtn4zI=
Message-ID: <7c86c4470806270810q4c739f25r44ed194a48cf7c1f@mail.gmail.com>
Date: Fri, 27 Jun 2008 17:10:43 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH 2/2] x86: add PCI extended config space access for AMD Barcelona
Cc: "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sourceforge.net, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080619155918.GD10019@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com>
	 <1213890640-4444-2-git-send-email-robert.richter@amd.com>
	 <20080619155918.GD10019@erda.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

This patch was applied to the perfmon GIT tree.
Please test.
Thanks.


On Thu, Jun 19, 2008 at 5:59 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 19.06.08 17:50:40, Robert Richter wrote:
>> This patch implements PCI extended configuration space access for
>> AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
>> addresses. An x86 capability bit has been introduced that is set for
>> CPUs supporting PCI extended config space accesses.
>>
>> Signed-off-by: Robert Richter <robert.richter@amd.com>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  arch/x86/kernel/cpu/cpu.h |    3 +
>>  arch/x86/pci/Makefile_32  |    1 +
>>  arch/x86/pci/Makefile_64  |    2 +-
>>  arch/x86/pci/amd_bus.c    |  560 +++++++++++++++++++++++++++++++++++++++++++++
>>  arch/x86/pci/direct.c     |   25 ++-
>>  arch/x86/pci/k8-bus_64.c  |  528 ------------------------------------------
>>  arch/x86/pci/pci.h        |    1 +
>>  7 files changed, 584 insertions(+), 536 deletions(-)
>>  create mode 100644 arch/x86/pci/amd_bus.c
>>  delete mode 100644 arch/x86/pci/k8-bus_64.c
>
> These patches are for the perfmon/master tree. They are based upon
> tip/x86/cpu.
>
> -Robert
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
> email: robert.richter@amd.com
>
>
