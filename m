Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0BGPKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 10:10:16 -0500
Received: from kcmailp04.birch.net ([216.212.0.99]:53626 "EHLO mx01.birch.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753088Ab0BGPKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 10:10:14 -0500
Message-ID: <4B6ED7E4.9020905@softplc.com>
Date: Sun, 07 Feb 2010 09:10:28 -0600
From: Dick Hollenbeck <dick@softplc.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Phillip Lougher <phil.lougher@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: SquashFS on ARM9
References: <4B6E0F88.2020402@softplc.com> <4B6E6959.60708@softplc.com> <cce9e37e1002070552h6514ecf5u634b184e4928a009@mail.gmail.com>
In-Reply-To: <cce9e37e1002070552h6514ecf5u634b184e4928a009@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher wrote:
> On Sun, Feb 7, 2010 at 7:18 AM, Dick Hollenbeck <dick@softplc.com> wrote:
>   
>> Dick Hollenbeck wrote:
>>     
>
>   
>> The image works OK if I build it with the 32 version of mksquashs on x86 vs x86_64 .
>>
>> Amazing, there are differences in file format other than endian-ness?
>>     
>
> If you've found a difference in filesystems built by mksquashfs on x86
> vs x86_64, then it is a *bug*.
>
>   
>> So we have at least 3 forms of the file system image now?  I am
>> disappointed.  One would have sufficed.  I don't even buy the need for
>> LSbyte vs MSbyte being needed.  There should have been only one form of the
>> FS image.
>>
>> Ouch, this seems amateurish.   Can I assume it is the bitfields?   Get rid
>> of the bitfields!
>>
>>     
>
> No need for insults, especially as it is based on an outdated
> understanding.  Squashfs became fixed endian, and lost the bit-fields
> in Squashfs 4.0.
>
>   
>> For now I don't need anymore help.  Sorry if I burned down my bridge, I only
>> intend to offer strategy to improve the filesystem.
>>
>>     
>
> I like constructive feedback, excessively critical feedback is usually
> self-defeating as it generally gets ignored.  By saying "Sorry if I
> burned down my bridge" means you obviously understand this, and so it
> is weird you bothered to send the email.
>
> If you'd like the bug tracked down please raise it on the
> squashfs.sourceforge.net bug tracker.  Include as much information as
> you can including distribution, architecture, Mksquashfs options etc.
> It would be best if you can provide a testcase set of source
> directories that generate differing Squashfs filesystems on
> x86/x86_64.
>
> Phillip
>   

My objection and criticism was based on my perception that *unnecessary 
risk had been taken* in using the bitfields.  I found no easy way to 
follow continuity of squashfs evolution, no mailing list, history doc, 
and made some assumptions based on an old LKML posting warning against 
bitfields.  I've been bit by bitfields myself in the past.  Typically 
human, my mistake was the same I was criticizing about, *taking 
unnecessary risk* when I made the assumptions.

I am sorry Phillip, your work is appreciated, your pay is too low, and 
you did not deserve this.

Dick


