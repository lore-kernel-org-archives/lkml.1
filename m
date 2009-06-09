Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZFIST6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZFIST6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZFISTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:19:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbZFISTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:19:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 00/27] score arch files for linux
Date: Tue, 9 Jun 2009 20:19:06 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OF54D30DF0.6974DE98-ON482575D0.0021670B-482575D0.00234606@sunplusct.com>
In-Reply-To: <OF54D30DF0.6974DE98-ON482575D0.0021670B-482575D0.00234606@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906092019.06812.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18b9yJb7yUDvRAMIWOqIlLWYTHRuzMHt9pTQyg
 5T23syL2eL2wn5Hv3HNZkCypr6g20WM7n5qfi2Om/MKoJN9A5Q
 wBl7I6yBWFuxuxHqEwRrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> Hi Arnd, Andrew Morton and linus,
> 
> According to your comment on score arch code, 
> we update score code base on asm-generic#next repository.
> use arch microblaze and blackfin as reference.

Ok, just finished looking over the patches and I am generally
very happy about their quality, it usually takes much longer
for a submission of this size to get into a mergeable shape.

The only thing that I think needs to be fixed before a
2.6.31 release is my comment about unistd.h still containing
the __ARCH_WANT_SYSCALL_* #defines. I consider that my fault
because I did not make it clear enough what those are meant
for in asm-generic/unistd.h.

One more general thought: I noticed that you split the header
files by alphabetical ordering. While there is no good way to
split a set of interdependent files, a logical grouping
(e.g. ABI, memory management, device, cpu) would be nice.

Everything else I found are only polite suggestions of what
can still be improved, not issues that I think need to
be addressed immediately. I especially love how the work
that Remis and I put into the generic header files starts
paying off, because it makes reviewing an architecture so
much simpler.

Please add my 'Reviewed-by: Arnd Bergmann <arnd@arndb.de>'
to your patches.

Thanks,

	Arnd <><
