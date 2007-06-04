Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbXFDNoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbXFDNoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXFDNoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:44:12 -0400
Received: from mail.suse.de ([195.135.220.2]:47282 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbXFDNoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:44:10 -0400
From: Andi Kleen <ak@suse.de>
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Date: Mon, 4 Jun 2007 15:43:48 +0200
User-Agent: KMail/1.9.1
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
References: <20070604112426.GA2707@elf.ucw.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706041543.49071.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 15:12, Jiri Kosina wrote:

> Are you sure that it's this dummy blink driver that makes the kernel
> stuck? I can't see how it could be causing any hogs - see commit f038f9.
>
> Anyway, added Andi to CC.

Hmm, in theory it could be triggering bugs in some buggy keyboard
controller. But then a 

while true ; do setleds +caps +numlock ; sleep 1 ; setleds -caps -numlock ; 
sleep 1 ; done

should trigger it too.

 Anyways; it is normally only intended for special
case kdump or other debugging kernels which tend to not get 
much interaction; you shouldn't really set it anywhere else.

I've been also considering to make it always dependent on
a command line option, but that is not done yet.

-Andi
