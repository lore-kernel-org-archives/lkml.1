Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966628Ab0B0ABU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:01:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:29521 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966604Ab0B0ABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:01:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jHSWCDzDXrL7rwOHeuP3z22uBDds6EgQ6Y0Ks/lA144FPHL4oIN+UjwZz3qK+zpUY
	jzs6lVrhNAOLDbRGehrnA==
Date: Fri, 26 Feb 2010 16:01:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
In-Reply-To: <alpine.DEB.2.00.1002261123520.7719@router.home>
Message-ID: <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com>
References: <20100215105253.GE21783@one.firstfloor.org> <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi>
 <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box> <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box>
 <alpine.DEB.2.00.1002261123520.7719@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Christoph Lameter wrote:

> > 1) numa memory hotadd never worked
> 
> Well Kamesan indicated that this worked if a cpu became online.
> 

That may be true, but it doesn't address hotpluggable 
ACPI_SRAT_MEM_HOT_PLUGGABLE entries for CONFIG_MEMORY_HOTPLUG_SPARSE where 
no cpus are being onlined or writing to /sys/devices/system/memory/probe 
for CONFIG_ARCH_MEMORY_PROBE.

> > 2) the rest just bitrotted because nobody tested it.
> 
> Yep. David: Can you revise the relevant portions of the patchset and
> repost it?
> 

Ok.
