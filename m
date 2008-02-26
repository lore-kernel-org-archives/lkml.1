Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYBZXbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYBZXbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765527AbYBZXbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:31:19 -0500
Received: from server54.tchmachines.com ([72.9.244.106]:53462 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765464AbYBZXbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:31:17 -0500
Date: Tue, 26 Feb 2008 15:31:11 -0800
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Message-ID: <20080226233111.GA9734@localdomain>
References: <20080226033945.GJ3143@localdomain> <20080226034625.GE21577@one.firstfloor.org> <20080226040541.GK3143@localdomain> <86802c440802252127i36fcd164xe6671aada160766a@mail.gmail.com> <20080226184235.GA5914@localdomain> <86802c440802261100j322ee6a6yef9108dc175de459@mail.gmail.com> <20080226203235.GH5914@localdomain> <86802c440802261310y176cdfel38843e264bc71f82@mail.gmail.com> <20080226212418.GJ5914@localdomain> <86802c440802261516n1ca8ef6eh5e6abdd0c3f959dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802261516n1ca8ef6eh5e6abdd0c3f959dd@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 03:16:16PM -0800, Yinghai Lu wrote:
>On Tue, Feb 26, 2008 at 1:24 PM, Ravikiran Thirumalai <kiran@scalemp.com> wrote:
>>
>> On Tue, Feb 26, 2008 at 01:10:57PM -0800, Yinghai Lu wrote:
>>  >On Tue, Feb 26, 2008 at 12:32 PM, Ravikiran Thirumalai
>>  ><kiran@scalemp.com> wrote:
>>  >> On Tue, Feb 26, 2008 at 11:00:58AM -0800, Yinghai Lu wrote:
>>  >>  >
>>  >>  >1. if acpi=off ?
>>  >>
>>  >>  Well that is not a realistic scenario for any multi chassi NUMA machine,
>>  >>  since the proximity information is very important and turning acpi off
>>  >>  deprives the OS of this information.
>>  >
>>  >actually OS should detect the distance instead of rely on SLIT.
>>
>>  How does it do that?  ACPI SRAT is needed to determine this, and it wouldn't
>>  work if acpi=off.
>
>srat only have apicid to node mapping, and ram to node mapping.

Which is very important for performance.

>
>for amd64 system, when acpi=off
>ram to node mapping can be retrieved from pci conf space

I was referring to all types of numa systems, not just AMD.  The pci config
space is amd specific.  Multi chassi systems in particular would be
acpi SRAT based.  Anyways.

Kiran
