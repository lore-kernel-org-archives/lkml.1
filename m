Return-Path: <linux-kernel-owner+w=401wt.eu-S1764983AbXHAOgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764983AbXHAOgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbXHAOgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:36:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbXHAOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:36:41 -0400
Message-ID: <46B09A57.8000403@zytor.com>
Date: Wed, 01 Aug 2007 10:36:07 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc1: no setup signature found...
References: <20070727013615.GC4570@gollum.tnic> <46A9753A.1010206@zytor.com> <20070729085059.GA10758@gollum.tnic> <20070729092402.GA2272@xguan-laptop> <20070729103706.GA16780@gollum.tnic> <46AC9B28.6060906@zytor.com> <20070729191528.GA5166@gollum.tnic> <46ADF02F.7010800@zytor.com> <20070730185359.GA4290@gollum.tnic> <46AE4E29.7060402@zytor.com> <20070801043835.GA4676@gollum.tnic>
In-Reply-To: <20070801043835.GA4676@gollum.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> 
> 	Breakpoint 4, 0x00040200 in ?? ()
> 	1: x/i ($cs << 4) + $eip  0x40300:      lea    (%si),%dx
> 	(gdb) c
> 	Continuing.
> 
> if i do delete here, it loads the second stage of grub and continues to load the
> kernel. Is there another way to land at the jmp instruction instead of poking
> blindly, maybe disassemble something parts of the initial code. \me reading
> grub-docs...
> 

If you do "delete" without a breakpoint number, you're deleting all 
breakpoints.  I just experimented with grub, and it looks like it should 
break at 0x90200, so just set that breakpoint and none of the others.

	-hpa

