Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbZEELJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbZEELJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZEELJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:09:11 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:33473 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbZEELJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:09:10 -0400
Message-ID: <4A001E51.4070903@davidnewall.com>
Date: Tue, 05 May 2009 20:39:05 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>,
       Olivier Galibert <galibert@pobox.com>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
References: <20090504124129.GL7141@linux.vnet.ibm.com> <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <1241451391.20170.12.camel@norville.austin.ibm.com> <m14ow0hnal.fsf@fess.ebiederm.org> <1241453259.20170.17.camel@norville.austin.ibm.com> <m1k54wal0j.fsf@fess.ebiederm.org> <20090504230357.GI6766@mit.edu>
In-Reply-To: <20090504230357.GI6766@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Mon, May 04, 2009 at 09:30:20AM -0700, Eric W. Biederman wrote:
>   
>> When all of the pieces are public how can having secret veiled reasons
>> make sense?
>>     
>
> Legal reasoning and strategy often needs to be kept confidential.

But those needs must defer to the open and public nature of the kernel. 
When you propose a change without saying why you giving the clear and
strong impression that something secret is going down and we should just
trust you.  That puts everyone in an awkward position because there's
now a risk that can't be properly evaluated.

Whether your patch goes in; whether it doesn't; it now seems there's
something fishy about long filenames, and to be safe, perhaps it would
be better to just turn off anything to do with FAT filesystems.  Who
would care, right?  Unless i turns out that Linux no longer has the
essential features.

Unless disrupting Linux was the point, and of course it isn't, it seems
that full disclosure is required.  And that's before any patch should
even be looked at.

> Note: We don't always ask people for the reason behind why they want,
> say, cgroups to control I/O throttling for example.  They may have a
> secret business case for how they will be able to leverage that
> technology with some application stack to make tons and tons of money
> --- and we don't require that deep motives be revealed in those cases.
>   

One might not  give the deep reason, but if no sufficient reason is
given then there's no sufficient reason and the answer is no.  We don't
want features just for the sake of another knob to twiddle.  It has to
be a *useful* knob.


> Or possibly it's because it is believed that [a patent] could be
> invalidated,
> which is why OIN is requesting prior art even though the last time to
> invalidate the patent through prior art was denied by the patent
> office.

Whether or not it's disclosed, you have to believe that any change
related to a patent issue will be noticed by people interested in that
issue.  You can make a disclosure without making an admission or claim. 
And then everybody understands what's going on.
