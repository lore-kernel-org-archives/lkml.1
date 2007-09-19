Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbXISSd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbXISSd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXISSdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:33:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbXISSdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:33:21 -0400
Message-ID: <46F16ADC.3030307@redhat.com>
Date: Wed, 19 Sep 2007 14:30:52 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: David Madore <david.madore@ens.fr>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: patch/option to wipe memory at boot?
References: <20070917155149.GA5453@clipper.ens.fr> <46EEC368.1040308@goop.org> <20070917204325.GA23658@clipper.ens.fr>
In-Reply-To: <20070917204325.GA23658@clipper.ens.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Madore wrote:
> On Mon, Sep 17, 2007 at 11:11:52AM -0700, Jeremy Fitzhardinge wrote:
>> Boot memtest86 for a little while before booting the kernel?  And if you
>> haven't already run it for a while, then that would be your first step
>> anyway.
> 
> Indeed, that does the trick, thanks for the suggestion.  So I can be
> quite confident, now, that my RAM is sane and it's just that the BIOS
> doesn't initialize it properly.
> 
> But I'd still like some way of filling the RAM when Linux starts (or
> perhaps in the bootloader), because letting memtest86 run after every
> cold reboot isn't a very satisfactory solution.

Bootloaders like to do things like run in 16-bit or 32-bit mode on boxes where 
higher bitness is necessary to access all the memory.  It may be possible to do 
this in the bootloader, but the BIOS is clearly the correct place to fix this 
problem.

	-- Chris
