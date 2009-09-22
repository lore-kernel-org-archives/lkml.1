Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbZIVNFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbZIVNFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbZIVNFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:05:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbZIVNFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:05:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steve Friedl <steve@unixwiz.net>
Subject: Re: [PATCH 2/8] staging: hv: Changed |typedef RING_BUFFER| to |struct hv_ring_buffer| throughout.
Date: Tue, 22 Sep 2009 15:05:18 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <20090922054026.GA5959@dcent.unixwiz.lan>
In-Reply-To: <20090922054026.GA5959@dcent.unixwiz.lan>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909221505.18816.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18/DmEyN3QHD/xgmuDafT2Mtra4q3YLWcVOY3B
 eHr9IkZI1P0aI7PllSeEVjLnFp9/v6qOc5tGqss/vGgyOqeSwy
 9xR1aArBmHN7uGQ6ICIvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Steve Friedl wrote:
> The style guide (and Greg's prior work) have suggested that the typedef
> UPPERCASENAME style is not appropriate in the Linux kernel (even though
> it's been de rigueur in Win32 development for 20 years), so I'm fixing
> a couple more of them that remain... one at a time.
> 
> ~~~ Steve
> 
> Signed-off-by: Steve Friedl <steve@unixwiz.net>

A few comments about your submission, not so much about this changes
in this patch specifically.

First of all, welcome here and thanks for your first submission!
Content-wise, all your patches look correct so far, nice work.

The patch comment above mixes both information about the contents of the
patch and information about the submission. The latter (as well as your
email signature) have no place in the changeset comment above the
'---' line but should go below it. They are good to have in the mail
but serve no purpose in the git history afterwards. As an example, you
could have written the same introduction as:

|[PATCH 2/8] staging: hv: Change typedef RING_BUFFER to struct hv_ring_buffer
|
|The typedef UPPERCASENAME style is not appropriate in the Linux kernel
|(even though it's been de rigueur in Win32 development for 20 years),
|so change 'typedef RING_BUFFER' to 'struct hv_ring_buffer'.
|
|Signed-off-by: Steve Friedl <steve@unixwiz.net>
|
|---
| The style guide (and Greg's prior work) have suggested doing that,
| and I'm fixing a couple more of them that remain... one at a time.
|
| ~~~ Steve
|
| drivers/staging/hv/RingBuffer.c |    6 +++---
| drivers/staging/hv/RingBuffer.h |    6 +++---
| 2 files changed, 6 insertions(+), 6 deletions(-)

It's also preferred to have the full series in a single email thread,
with all patches as a reply to the introductory mail. git-send-email
does that with the '--thread --no-chain-reply-to', git-format-patch
does the same with 'thread=shallow' (great job on consistency ;-) ).

You should also Cc the right mailing lists and people for the subsystem
you are patching. If you don't know them, use scripts/get_maintainer.pl.
'scripts/get_maintainer.pl -f drivers/staging/hv/*' currently returns
Greg Kroah-Hartman <gregkh@suse.de>
Nicolas Palix <npalix@diku.dk>
Hank Janssen <hjanssen@microsoft.com>
Haiyang Zhang <haiyangz@microsoft.com>
Bill Pemberton <wfp5p@virginia.edu>
Randy Dunlap <randy.dunlap@oracle.com>
Jan Beulich <jbeulich@novell.com>
Moritz Muehlenhoff <jmm@debian.org>
devel@driverdev.osuosl.org
linux-kernel@vger.kernel.org

By looking at 'git log drivers/staging/hv', you can also determine that
Randy, Jan and Moritz each only contributed a single patch, so they
are not likely to be interested in your changes, but it would not
be harmful to Cc them.

Also, you should check if there is a maintainer tree that already addresses
the problems you are fixing or if there are possibly conflicts with other
changes in that tree, not sure if you did that but I've seen a number of
similar patches for the hv drivers so it would be possible that someone
else did the same already.

	Arnd <><
