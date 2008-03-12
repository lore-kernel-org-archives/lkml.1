Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926AbYCLLeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbYCLLeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 07:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYCLLek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 07:34:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38488 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYCLLej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 07:34:39 -0400
Message-ID: <47D7BF6C.3080306@jp.fujitsu.com>
Date: Wed, 12 Mar 2008 20:33:00 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de> <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de> <20080304230937.GD3694@ldl.fc.hp.com> <47CDF339.3060304@jp.fujitsu.com> <20080305202052.GN3694@ldl.fc.hp.com> <47D684D0.6060200@jp.fujitsu.com> <20080311110403.7db9527c@appleyard> <20080311191406.GB29344@ldl.fc.hp.com>
In-Reply-To: <20080311191406.GB29344@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san,

> On my machine, it is legal to evaluate S1F0._SUN independent of
> S1F0._STA because L001._INI has already been evaluated.
> 
> It would be helpful to know what Fujitsu's namespace looks like.
> If Fujitsu slot objects contain _STA and _INI, then I agree with
> Kenji-san -- I definitely need to check _STA before evaluating
> _SUN.

Thank you for explanation. Maybe I understood the summary of
implementation of HP firmware. But how to use or where to put _INI
method in the ACPI namespace never becomes reasonable reason why
your driver may ignore _STA before evaluating _SUN.

> But in any case, I think both HP and Fujitsu firmware are doing
> legal things -- neither firmware is breaking the spec.

My understanding of your explanation so far is:

- evaluating _SUN without checking _STA doesn't cause problem,
  from the view point of HP's implementation.
- some IBM machine is doing same as HP

I never think those are reasonable reasons why ignoring _STA
before evaluating _SUN is legal. Am I missing something?

> If one list is shorter than the other, then that should be the
> list to put in the kernel, and the default behavior should be
> "majority rule".

I don't want to consider "majority rule" before I understand why
ignoring _STA is legal.

Thanks,
Kenji Kaneshige

