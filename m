Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0CBPEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:04:06 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50083 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0CBPED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:04:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FB69I5UkVKOTTDFZFn7Tk044ogIfOsyESH25/KI557+S0apXyp7gXvT/quGyHvvzrl
         SeFxysfugxVR55OC7ToXxMiaIMDJMNuLdw/fK795BgOQDF10Yx0XcPN6pec9KBzyxB/F
         3kycz7H6TUnn84I0SCPepNEJfH0rrefFHkAUo=
MIME-Version: 1.0
In-Reply-To: <20100302125306.GD19208@basil.fritz.box>
References: <alpine.DEB.2.00.1002240949140.26771@router.home>
	 <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1002251228140.18861@router.home>
	 <20100226114136.GA16335@basil.fritz.box>
	 <alpine.DEB.2.00.1002260904311.6641@router.home>
	 <20100226155755.GE16335@basil.fritz.box>
	 <alpine.DEB.2.00.1002261123520.7719@router.home>
	 <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com>
	 <20100302125306.GD19208@basil.fritz.box>
Date: Tue, 2 Mar 2010 17:04:00 +0200
X-Google-Sender-Auth: c1fadf8718e952ff
Message-ID: <84144f021003020704s3abafc24t9b8ab34234094b79@mail.gmail.com>
Subject: Re: [patch] slab: add memory hotplug support
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Tue, Mar 2, 2010 at 2:53 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Mon, Mar 01, 2010 at 02:24:43AM -0800, David Rientjes wrote:
>> Slab lacks any memory hotplug support for nodes that are hotplugged
>> without cpus being hotplugged.  This is possible at least on x86
>> CONFIG_MEMORY_HOTPLUG_SPARSE kernels where SRAT entries are marked
>> ACPI_SRAT_MEM_HOT_PLUGGABLE and the regions of RAM represent a seperate
>> node.  It can also be done manually by writing the start address to
>> /sys/devices/system/memory/probe for kernels that have
>> CONFIG_ARCH_MEMORY_PROBE set, which is how this patch was tested, and
>> then onlining the new memory region.
>
> The patch looks far more complicated than my simple fix.

I wouldn't exactly call the fallback_alloc() games "simple".

> Is more complicated now better?

Heh, heh. You can't post the oops, you don't want to rework your
patches as per review comments, and now you complain about David's
patch without one bit of technical content. I'm sorry but I must
conclude that someone is playing a prank on me because there's no way
a seasoned kernel hacker such as yourself could possibly think that
this is the way to get patches merged.

But anyway, if you have real technical concerns over the patch, please
make them known; otherwise I'd much appreciate a Tested-by tag from
you for David's patch.

Thanks,

                        Pekka
