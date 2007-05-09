Return-Path: <linux-kernel-owner+w=401wt.eu-S935156AbXEIF7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156AbXEIF7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934722AbXEIF7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:59:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933700AbXEIF7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:59:09 -0400
Message-ID: <46416327.3080007@zytor.com>
Date: Tue, 08 May 2007 22:59:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 464bdd33e9baad9806c7adbd8dfc37081a55f27e
References: <46413851.6070505@zytor.com> <1178690193.4747.16.camel@daplas>
In-Reply-To: <1178690193.4747.16.camel@daplas>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> On Tue, 2007-05-08 at 19:56 -0700, H. Peter Anvin wrote:
>> Checkin 464bdd33e9baad9806c7adbd8dfc37081a55f27e "fbdev: ignore VESA
>> modes if framebuffer is disabled" is just plain wrong on any system
>> which has support for extended text modes in its VESA BIOS.
>>
>> Antonio is incorrectly assuming this branchout is used only to set VESA
>> graphics modes, but it's to set any VESA mode, be it text or graphics.
>>
> 
> Okay.
> 

I did, however, take a cue from this and the setup rewrite now makes the
VESA graphics mode unselectable if CONFIG_FB is off.

See:
http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=shortlog

	-hpa
