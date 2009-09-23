Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZIWTKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZIWTKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZIWTKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:10:18 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:38300 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZIWTKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:10:17 -0400
Date: Wed, 23 Sep 2009 21:10:19 +0200
Message-Id: <925249445@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] DRBD for 2.6.32
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/YgoTsw3pER/fCQoG/wUW80m4O/5e9CsWpPBYkMFaWjkTyv
 gAaQM53F/5FHYqKBoxJM7iv5wzpGrfyZ+CWRaj4z47gvkHcats=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel developers, 

looking at this from a user/admin/system-engineer perspective, to be honest:  i think this discussion sucks !

sorry for being a little bit offensive, but the DRBD people did their homework and they did it well, and now you scare them away with this deferred "ohhh, not another raid implementation" discussion.

you also scare away DRBD users, at least you scare ME away, as i loose trust in Linux and loose trust in DRBD to be a "solution with a future".

quoting fujita:
>Anyway, I don't think that your example is fair; we need a driver
>for scsi hardware but we have an alternative to drbd.

no, i don`t think there is a real alternative to DRBD. At least not now. I´m quite sure we won`t have something as feature rich, as stable and as usable within the next year.

dm-replicator? come on!

to give an example, of how long development of kernel features may last:  for how long is BTRFS being discussed and being introduced now? 
announcement is more than 2 years ago, but it´s in mainline.
i can create snapshots for ages - but why can`t i still delete them?
how can something go mainline which is a "work-in-progress", missing important features and still may get on-disk-layout changes? 
is there a different rule for integrating filesystems? 
Colognian cliquishness, or what?  ;-)

to my sorrow, i now drop my linux based storage server undertaking and give Solaris/ZFS + ZFS replication a try. 
that will probably also fit. and works. and is supported.

use a distro which includes DRBD ? 
uhhhm, no......you guys don`t like it...so i don`t like it.  
at least using tainted kernel without upstream support is something to avoid....

my 10 cents
roland




>On Wed, Sep 23, 2009 at 07:57, Christoph Hellwig <hch@infradead.org> wrote:
>> On Mon, Sep 21, 2009 at 08:51:32PM -0400, Kyle Moffett wrote:
>>> You have to realize that this project is NOT a new one, it's been
>>> around quite a decent number of years (since kernel 2.2-ish). Â Yes,
>>> the ABI is unique and has its warts, but there are a lot of things
>>> that depend on it.
>>
>> So? Â That's never been an argument. Â Quite contrary, we ignored upstream
>> for years and fucked up out of tree but please merge anyway is almost
>> a counter-argument.
>
>That's not what happened with DRBD at *all*.  It was a large project
>that ignored upstream for a while yes... but recently they decided to
>do things right and submitted all of their patches for review and
>comments.  After a good number of review cycles during which they were
>model citizens for making big necessary changes, nobody could find
>anything technically wrong with the code.
>
>Now people are asking the out-of-tree project to continue to maintain
>their otherwise-perfectly-merge-ready patchset while also implementing
>a bunch of MD/DM/RAID-integration code.  Meanwhile several of the
>DM/MD RAID guys who *already* have their code upstream have not been
>having much luck defining a usable userspace API for the proposed
>integrated configuration model.
>
>At the very least, the code is at the point where Greg KH could easily
>merge it into staging:
>  * The code is under GPLv2
>  * The goal of the developers is to get it merged in the near future
>  * It builds properly on x86
>  * It's for a new feature (not an existing one)
>  * There's a reliable point-of-contact for the code
>
>The only thing missing is a list of exactly what still needs to be
>fixed.  I see a lot of handwaving about "We want a new API", but
>nobody defining what the requirements for that are.  If nobody can
>figure that out yet, then I see no reason it shouldn't be mainline
>mergeable; both Neil Brown and Jens Axboe seem to think this is ready
>to merge as well.
>
>Cheers,
>Kyle Moffett

______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

