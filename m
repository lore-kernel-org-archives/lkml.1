Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbXDZHPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbXDZHPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXDZHPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:15:09 -0400
Received: from main.gmane.org ([80.91.229.2]:43587 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbXDZHPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:15:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andy Grover <andy@bandradar.com>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
   hang in atomic copy)
Date: Thu, 26 Apr 2007 00:08:07 -0700
Message-ID: <46304FD7.7050204@bandradar.com>
References: <20070419070437.GA25211@elte.hu>	<20070424202336.GC16503@elf.ucw.cz>	<alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>	<20070424212408.GD16457@elf.ucw.cz>	<alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>	<20070425072350.GA6866@ucw.cz>	<Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>	<alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>	<20070425202741.GC17387@elf.ucw.cz>	<alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>	<20070425214420.GG17387@elf.ucw.cz>	<alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>	<20070425235718.66b71f01@the-village.bc.nu>	<alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org> <20070426012454.3495b5d8@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: gateway.groveronline.com
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
In-Reply-To: <20070426012454.3495b5d8@the-village.bc.nu>
Cc: suspend2-devel@lists.suspend2.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> Mind you some laptops think S2RAM is just a transition state on the way
> to disk, leave them in ACPI S2RAM and the firmware will magically turn it
> into a save to disk and back to ram if the battery runs low or you leave
> it idle too long.

The OS does this (or at least it's supposed to). STR with battery low,
it comes back on fully via a battery wake event, and then STD (aka
snapshot/poweroff). The ACPI state machine always goes through S0, FWIW.

OK, now back to the "should we have 2 function pointers or 4" debate...

-- Andy

