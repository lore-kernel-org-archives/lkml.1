Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbZAOLAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbZAOLAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763287AbZAOK7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:59:51 -0500
Received: from mailx.swiss-it.ch ([81.6.4.203]:40821 "EHLO mailx.swiss-it.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762990AbZAOK7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:59:50 -0500
X-Greylist: delayed 1915 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 05:59:50 EST
Message-ID: <496F10EC.9010702@codelabs.ch>
Date: Thu, 15 Jan 2009 11:33:16 +0100
From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Balaji Rao <balajirrao@openmoko.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_MFD_PCF50633=m breaks the kernel build
References: <20090115100653.509416fb@hyperion.delvare>	<20090115091107.GB3199@fedora.yogi> <20090115110955.4a8e9c5b@hyperion.delvare>
In-Reply-To: <20090115110955.4a8e9c5b@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Thu, 15 Jan 2009 14:41:08 +0530, Balaji Rao wrote:
>> On Thu, Jan 15, 2009 at 10:06:53AM +0100, Jean Delvare wrote:
>>> Hi Balaji,
>>>
>>> Building kernel 2.6.29-rc1-git4 on x86_64 with CONFIG_MFD_PCF50633=m
>>> fails at linking time with:
>>>
>>> ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
>>> ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
>> Yes, I've seen this. The fix is waiting on linux-mfd to be pulled
>> anytime soon.
> 
> Where is linux-mfd? And what is it, a git tree, a mailing list? I
> couldn't find any reference.

git://git.o-hand.com/linux-mfd

> Can you please send me the patch now, so that I can fix my build
> locally right now?

The related commit:
http://git.o-hand.com/cgit.cgi/linux-mfd/commit/?h=for-linus&id=9bf04a9690b3c961150ac508d343c875f0d641ad

Adrian
