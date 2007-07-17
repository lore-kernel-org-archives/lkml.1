Return-Path: <linux-kernel-owner+w=401wt.eu-S935134AbXGQPqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134AbXGQPqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934625AbXGQPle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:41:34 -0400
Received: from mx1.suse.de ([195.135.220.2]:47354 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934618AbXGQPlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:41:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ACPI: Add reboot mechanism
Date: Tue, 17 Jul 2007 17:41:27 +0200
User-Agent: KMail/1.9.6
Cc: Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, akpm@osdl.org
References: <fa.IMXKKgfBkv/U+MG0xx5sLkpV2Ws@ifi.uio.no> <fa.+iOE+OqrQUbecN788fV4aEhLLtg@ifi.uio.no> <469CD4B8.9070506@shaw.ca>
In-Reply-To: <469CD4B8.9070506@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171741.27628.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 16:39:52 Robert Hancock wrote:
> Andi Kleen wrote:
> > On Monday 16 July 2007 20:00:19 Aaron Durbin wrote:
> >> Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.
> > 
> > Why? I had such a patch at some point as experiment, but it never
> > helped actually fix a box.
> 
> Depends if Windows resets using this method,> in that case using it as  
> well would likely prevent the steady trickle of machines that seem to 
> have trouble with other reset methods and need blacklist entries..

It's not that easy -- there are different windows versions out who
do different things. Sometimes systems are built for older windows
versions, sometimes systems are built for newer windows versions.
They don't necessarily work on newer versions.
But people expect Linux to run on all of them.

> I sometimes think that with these sorts of things where basic 
> functionality like reboot is broken, 

I'm not aware of that many systems where reboot doesn't work.
Also I'm sure there are some who don't reboot even in Windows.

Another reason is probably that reboot is quite hard to debug.

One recently new problem is that some systems don't have keyboard
controllers anymore so that method obviously doesn't work. But 
it doesn't hurt to try it first because it's unlikely to break
something

The triple fault fallback is normally quite reliable though.

I would expect that putting the ACPI method in the middle
is probably safe enough.

-Andi
