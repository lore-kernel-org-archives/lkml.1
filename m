Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0CIGxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:53:42 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:56879 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab0CIGxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:53:39 -0500
Message-ID: <4B95F071.3070400@msgid.tls.msk.ru>
Date: Tue, 09 Mar 2010 09:53:37 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Karel Zak <kzak@redhat.com>,
       Jim Meyering <jim@meyering.net>, Neil Brown <neilb@suse.de>
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com>
In-Reply-To: <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer wrote:
[]
> I've been keeping track of all the pieces in play, have coordinated
> with kzak and jim, and have a summary that offers some amount of macro
> detail (at the end I touch on parted and fdisk):
> 
> http://people.redhat.com/msnitzer/docs/io-limits.txt

What I don't see in this thread and in this document is - any mention
of linux md layer.  I think it is the first candidate to test the whole
thing, the easiest and most important one.  I mean the alignment and
"recommended I/O size" and all this similar stuff.

Think of a raid5 array - with all the mentioned good stuff in place
fdisk should figure out to align partitions on the array stripe
boundary, and should do that automatically.  And this should be
most easy to debug/test, since the whole thing is controllable
by kernel.

But apparently it does not implement anything of this sort.
Adding Neilb to the Cc list.......

Thanks!

/mjt
