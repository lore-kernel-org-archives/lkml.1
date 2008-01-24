Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbYAXVb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbYAXVb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbYAXVbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:31:20 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51326 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYAXVbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:31:19 -0500
Date: Thu, 24 Jan 2008 22:31:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Dave Jones <davej@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Recursive variable `KBUILD_CFLAGS' references itself (eventually).
In-Reply-To: <20080124212743.GB3944@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0801242231040.12676@fbirervta.pbzchgretzou.qr>
References: <20071120001445.GA9243@redhat.com> <20071231131619.GE21871@uranus.ravnborg.org>
 <20071231161021.GC27655@redhat.com> <20080124212743.GB3944@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 22:27, Sam Ravnborg wrote:
>>  > > Trying to do a 32bit build on a 64bit machine.
>>  > > I did..
>>  > >   make ARCH=i386 oldconfig
>>  > >   make ARCH=i386 arch/x86/
>>  > 
>>  > Walking through my mailbox I found this one.
>>  > I did not get similar reports and I cannot reproduce it.
>>  > Do you continue to see this or had it been fixed somehow?
>> 
>> Still happens for me with the latest tree from git.
>> 
>> $ make ARCH=i386 arch/x86/
>
>There is no easy fx for this one.
>You try to build one of the non-standard directories and it just
>fails because arch/x86/Makefile is not a regular Kbuild file.
>
>Try with any other directory (almost any other) and it works.
>Considered unfortunate but not a bug - so I will not try to fix it.

So, how are we going to build only arch/x86/ right now with kbuild?
