Return-Path: <linux-kernel-owner+w=401wt.eu-S969761AbXEIHEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969761AbXEIHEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 03:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969346AbXEIHDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:03:37 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57495 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969441AbXEIHDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:03:36 -0400
Message-ID: <46417215.6060204@zytor.com>
Date: Wed, 09 May 2007 00:02:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com> <20070509065122.GA5360@uranus.ravnborg.org>
In-Reply-To: <20070509065122.GA5360@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> http://www.kernel.org/pub/linux/kernel/people/hpa/newsetup-36f021b5.patch
> 
> Are you planning to rebase to -linus and then let
> arch/x86_64/boot/Makefile be a reference to i386/boot/Makefile?
> 
> The patch for kbuild to enable this is in -linus now.
> 
> As for the important part (the code) I have not looked.

I have rebased to -linus, but I'm a bit scared about making that
particular change at this time, mostly because it requires some
additional Makefile work which I would be happier to apply later, in
order to make the "create clean patchset" task easier.

All the source code is shared, but for right now the Makefiles are
slightly different, mostly w.r.t. CFLAGS.

	-hpa
