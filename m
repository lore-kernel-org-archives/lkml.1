Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0BOTdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:33:13 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:59929 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab0BOTdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:33:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rtbbRc7wf+1XCcjkGl9S8oyuCwtmBQpqnSEGTHDDEczpx9ZiUD4Zad2XEpVcE+85RW
         kWjX2j0tlbrzgdy+ygDUTmpaQHtgqwujn8c6HlIvfyOLuj4+xp6b2NI1W4U7lDWdVTt/
         LWM/SdvaiUQOvweU62m+2J6z1zfbXXvvU/DCc=
MIME-Version: 1.0
In-Reply-To: <1266100773.23181.8.camel@thorin>
References: <4B744E13.8040004@kernel.org>
	 <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
	 <4B75A5DC.3060803@kernel.org>
	 <20100212202357.6363d5af@hyperion.delvare>
	 <20100212230702.GA10266@1wt.eu>
	 <20100213091748.276821e1@hyperion.delvare>
	 <4B767810.5020707@s5r6.in-berlin.de> <4B767C67.7060701@redhat.com>
	 <alpine.LNX.2.01.1002131233450.30803@filesrv1.baby-dragons.com>
	 <1266100773.23181.8.camel@thorin>
Date: Mon, 15 Feb 2010 13:33:10 -0600
Message-ID: <524f69651002151133v475ebd02r80837adfc428fbfd@mail.gmail.com>
Subject: Re: [kernel.org users] [kernel] Re: XZ Migration discussion
From: Steve French <smfrench@gmail.com>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Avi Kivity <avi@redhat.com>,
       Jean Delvare <khali@linux-fr.org>, users@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 4:39 PM, Bernd Petrovitsch
<bernd@petrovitsch.priv.at> wrote:
> On Sam, 2010-02-13 at 12:37 -0900, Mr. James W. Laferriere wrote:
>> On Sat, 13 Feb 2010, Avi Kivity wrote:
> [...]
>> > Can you even unpack a kernel tree on Windows?  There are some files (e.g.
> Given a sane filesystem, yes. If (the) native filesystem(s) are sane, is
> more a flamebait than anything else.
>
>> > net/ipv4/netfilter/ipt_{ecn,ECN}.c) which conflict on a case-preserving
>> > filesystem.
>>       What filesystem version are you talking about ?
> All of NTFS (and basically FAT*). Are there are different versions? If
> yes, how do I tell?
>
>>       ntfs as of recent windows is not case insensitive .
> It *is* case insensitive (as it compares filesystem names
> case-insensitive on the equivalent of an open() syscall).

There are case sensitive Windows subsystems (e.g. SFU/SUA
at least when running over NTFS), and the default behavior for
Win32 apps even can be changed to be case sensitive
via a registry key: ObCaseInsensitive).

More important is how easy it is to install - since XZ is
not even available via apt-get install on recent
distros (e.g. April 2009 Ubuntu 9.04), this discussion
seems about a year premature.

-- 
Thanks,

Steve
