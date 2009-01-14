Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbZANXAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbZANXAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 18:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZANXAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 18:00:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:29632 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbZANXAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 18:00:35 -0500
MIME-Version: 1.0
In-Reply-To: <1231969221.8269.50.camel@think.oraclecorp.com>
References: <20090112190420.51f75853@pedra.chehab.org>
	 <20090113105947.9e774b69.akpm@linux-foundation.org>
	 <20090113191757.74290@gmx.net>
	 <20090113113700.776a94b5.akpm@linux-foundation.org>
	 <20090113203843.GJ29283@parisc-linux.org>
	 <1231957750.8269.28.camel@think.oraclecorp.com>
	 <496E56EB.2030301@gmx.de>
	 <1231968240.8269.48.camel@think.oraclecorp.com>
	 <496E5AB2.7040507@sandeen.net>
	 <1231969221.8269.50.camel@think.oraclecorp.com>
Date: Thu, 15 Jan 2009 00:00:32 +0100
Message-ID: <ac3eb2510901141500w5950c61dyba8af2e1d515ee08@mail.gmail.com>
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
From: Kay Sievers <kay.sievers@vrfy.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, wk <handygewinnspiel@gmx.de>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl, HWerner4@gmx.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 22:40, Chris Mason <chris.mason@oracle.com> wrote:
> On Wed, 2009-01-14 at 15:35 -0600, Eric Sandeen wrote:
>
>> >> Attached the log from stracing the command which was ivoked by the
>> >> Makefile from v4l-dvb.
>> >> I guess this is all i could contribute to that problem. Thats stuff for
>> >> xfs filesystem experts now..
>> >
>> > Seems suspect indeed.  Could you please attach the strace for the run
>> > that works on the older kernel?
>>
>> Chris got my attention on this one; you probably want this fix from hch:
>>
>> http://oss.sgi.com/archives/xfs/2009-01/msg00158.html
>
> Seems like this one should get queued for -stable as well if it isn't
> already.

Chris, is this similar to the thing we've seen with btrfs? Is this fixed?

 "> I see the same issue on x86 32 bit, with the additional __llseek()
  > between the getdents64(), and the last entry returned by readdir
  > ignored.
  >
  > If I change the returned LLONG_MAX to LONG_MAX in inode.c, it all
  > works fine, and the __llseek() disappears.

  Ok, thanks I'll work up a patch."

  http://article.gmane.org/gmane.comp.file-systems.btrfs/1774

Thanks,
Kay
