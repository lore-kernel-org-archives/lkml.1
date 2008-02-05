Return-Path: <linux-kernel-owner+w=401wt.eu-S1762202AbYBEVnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202AbYBEVnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbYBEVmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:42:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbYBEVmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:42:53 -0500
Message-ID: <47A8D82A.8080704@zytor.com>
Date: Tue, 05 Feb 2008 13:42:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 updates
References: <20080204161219.GA8092@elte.hu> <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org> <20080205192236.GA26426@uranus.ravnborg.org> <20080205210508.GA14708@elte.hu> <47A8D088.7050209@zytor.com> <20080205211854.GB27589@uranus.ravnborg.org> <47A8D3CF.2080608@zytor.com> <alpine.LFD.1.00.0802051330240.3110@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802051330240.3110@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Well, the real question is "what are the defaults"
> 

Well, I guess my point was that we shouldn't rely on the defaults.

>> By default:
>>
>> .bss 	is (aw,nobits).
>> .data 	is (aw,progbits).
>> .rodata	is (a,progbits).
>> .text	is (ax,progbits).
> 
> But what about something like ".init.data"?
> 
> I'd assume the defaults for unrecognized segments would have to be 
> something sane like (aw,progbits) (ie my patch shouldn't make any 
> difference), but where do we find that out?

The defaults are undocumented, and thus could change from one binutils 
version to another.  Experimentally, with 
binutils-2.17.50.0.18-1.x86_64, a section named ".init.data" get 
("",@progbits) as the default attributes.

	-hpa
