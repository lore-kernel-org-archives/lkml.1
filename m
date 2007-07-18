Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXGRQCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXGRQCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbXGRQCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:02:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888AbXGRQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:02:42 -0400
Message-ID: <469E3806.4030804@zytor.com>
Date: Wed, 18 Jul 2007 08:55:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de>
In-Reply-To: <p737ioyxwyq.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
>> Already with these patches I can compile a zImage kernel that is 450kb
>> large (890kb decompressed)
> 
> The important part is not how big the vmlinux is, but how much
> memory is actually used after boot. 
> 
> I expect concentrating some of the dynamic data structures would
> be more fruitful in fact.
> 

Well, how big the vmlinux file is matters if it doesn't fit in memory
with enough time to get to the phase where it is dumping the init
sections.  *If that is not the issue*, then axing stuff like CPUID is a
major lose in terms of code maintainability for zero gain.

	-hpa
