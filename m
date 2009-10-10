Return-Path: <linux-kernel-owner+w=401wt.eu-S1759662AbZJJMUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662AbZJJMUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 08:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758268AbZJJMUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 08:20:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:10582 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbZJJMUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 08:20:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DhobVIKzfD84eYtj+8FFfPIDV9coYbLDtqnGHoD1riSGcvvQI0naUuN0xv6O/V4dLF
         oSgCp9YEMl+fAKMfT4Z42YrrXMJFbU2HpdUoUl3AbCBqRFe6567a3jmi7YbVT+ZMKWHz
         uf11Zii+YWwieiCXY+J6ux9wtFRlbjTJbkBXE=
MIME-Version: 1.0
In-Reply-To: <20091010120950.GD1811@ucw.cz>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <1254864803.6035.25.camel@pasglop>
	 <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain>
	 <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com>
	 <20091007023119.GJ17883@mit.edu> <20091010120950.GD1811@ucw.cz>
Date: Sat, 10 Oct 2009 15:18:52 +0300
Message-ID: <94a0d4530910100518j53965ea2kda5ed9d81ee55e7b@mail.gmail.com>
Subject: Re: Linux 2.6.32-rc3
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Theodore Tso <tytso@mit.edu>, Dave Airlie <airlied@gmail.com>, G@ucw.cz,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 3:09 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2009-10-06 22:31:19, Theodore Tso wrote:
>> On Wed, Oct 07, 2009 at 11:22:38AM +1000, Dave Airlie wrote:
>> >
>> > Why don't you just have the kernel version Linux-commitid?
>> >
>> > why keep up the pretense that the 2.6.xx bit means anything outside of release?
>> >
>> > You could just have the tarball generation scripts make it into a 2.6.31 but
>> > for everyone else we never see it.
>>
>> The tarball generation scripts for the daily snapshots already set
>> EXTRAVERSION to -git15, -git16, etc.
>>
>> So the problem seems to be localized to those users/developers who are
>> smart enough to use git, and dumb enough not to set
>> CONFIG_LOCALVERSION_AUTO.  So big of a set this actually is, I can't
>> say.  Do we have any statistics about how many bug reporters make this
>> mistake?
>
> I admit -- I did not know about LOCALVERSION_AUTO, and many times
> wished -rc0 would be labeled as such.
>
> Now...perhaps LOCALVERSION_AUTO should not be option? Just hardwire it
> to Y? (But that still does not solve systems when someone, probably
> me, did rm -rf .git, for space and speed reasons).

Why is LOCALVERSION_AUTO part of the config file? Shouldn't it be on
the Makefile? Then it's easy for people to override it if they want.
And it's also easy for packagers, for whatever wicked reasons.

-- 
Felipe Contreras
