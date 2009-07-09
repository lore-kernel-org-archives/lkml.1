Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbZGIBVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbZGIBVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 21:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbZGIBU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 21:20:58 -0400
Received: from mail.samba.org ([66.70.73.150]:33797 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759407AbZGIBUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 21:20:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19029.17896.769106.375379@samba.org>
Date: Thu, 9 Jul 2009 11:20:40 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <20090708142510.5068b4c3@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<19028.31088.400461.939917@samba.org>
	<20090708130256.40957c3f@lxorguk.ukuu.org.uk>
	<19028.39145.180869.603673@samba.org>
	<20090708142510.5068b4c3@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > The vendors can only talk to one another with lawyers present, so this is
 > an irrelevant argument to the public kernel. We've proved that already in
 > the fact you can't even discuss implementation details with the list.

We have discussed implementation details on this list. We've shown the
code, and a FAQ on how the code works. 

The situation is much more subtle with regard to what can be publicly
discussed than what you make out. Think of it like the media training
that many engineers get in companies these days. You need to learn
what words can and cannot be used. I think it is perfectly possible to
have public discussions of patents such as we are having right now. 

I grant you that it is very unusual to do this, but I would like to
see that change.

 > > You talk about media players and other software being crippled in the
 > > US and other countries as though this is a good thing. You talk about
 > > vendors ripping out large slabs of functionality as though you want it
 > > to happen.
 > 
 > It is what the vendors will do regardless.

no, when the vendors are given a clearly non-infringing way of
implementation then I think they will go for it. The proof is that
they still ship Samba, which includes patent workarounds, and I'm sure
there are plenty of other free software packages which similarly have
patent workarounds and that are shipped with distros all the time.

 > This misses the fact that if the vendor thinks sueing you is a business
 > opprtunity they will do so anyway. Why should they care if the patent is
 > valid - its not relevant to most of the legal process so it still has the
 > desired slowdown and expend money approach

you are mixing up "validity" and "non-infringment". If my argument was
in any way based on a patent being "invalid" then you would be right,
because a court is required to start from the assumption that a patent
is valid. Trying to fight a patent based on invalidity is really
really hard.

The court is not required to start with the assumption that a piece of
code infringes a patent - quite the opposite in fact. If the defendent
can show a clear argument as to why it is not infringing then the
patent holder quickly loses.

Do you know of any example where a defendent had a really good
non-infringment argument and still lost a case?

 > If you wanted reliable working approach surely tridgefat should read long
 > names but only create new short names ? That keeps you in spec, as I
 > understand it avoids the alleged possible patent infringement and works
 > for all devices ?

'works' for all devices, except that any Linux users copying a file
with a long name to the device get an error. That is not my idea of
'works'.

My patch in May proposed that solution because of it's simplicity, not
because it was the best solution. It was the first solution I thought
of, and I'm sure others thought of it too, but it loses so much
functionality that it would be a very painful solution for Linux
vendors.

The dualnames patch achieves a much higher degree of functionality for
a much wider number of users. It isn't perfect, but I think it is much
better.

 > Many of the things removed are not patent related. Patents are only one
 > issue. Stuff gets removed for many reasons including a few cases of "they
 > sue everyone who does this regardless of validity so we don't XYZ"

again, this is validity, not non-infringment. I am not advocating a
"you're patent is invalid" argument, as that is not certain enough. I
am advocating a "we don't implement that" approach.

 > I've spent over ten years doing that. Those ten years have taught me
 > 
 > - if you give in to a patent thug they will simply try to bully you
 >   further

and what did TomTom do on these patents? They had to give in, because
they didn't have a workaround. What has that taught the patent holders
of the world?

I'd like to teach patent holders that if you assert a patent against a
free software implementation of any bit of technology that you will
have a huge group of engineers working on stomping all over your
patent, thus threatening the nice little revenue stream you have from
other proprietary licensees.

We need to be seen as the guys with the big club who even the bullies
don't mess with. 

The great thing about this is that it works even better with patent
trolls. Their sole purpose in life is to derive revenue from their
patents. If we become known as the guys who threaten that income then
the trolls will give us a wide berth. 

This is an advantage that only the free software community has. If a
proprietary vendor finds a patent workaround then they will keep it
secret, as they don't want the other proprietary vendors to be able to
avoid the license fee. That means the trolls lose just one victim if a
proprietary vendor finds a workaround. With the free software
community our open code means that the trolls will be risking their
entire revenue stream from the patent by attacking any vendor based on
free software. That puts us in a uniquely strong position in the
patent world.

 > - if you limit functionality silently or in an unreliable way the blame
 >   falls on the software supplier not the patent holder or the governments
 >   who made the bad laws (or the judges of course as software patents
 >   in many states aren't really of political origin but judicial
 >   over-reach)

And if we make it so that copying files to a FAT filesystem return
-1/ENAMETOOLONG then what will that do to users? You really think
users will have sympathy with the situation then?

 > - if you delete stuff from base packages you hurt people in the rest of
 >   the world unneccessarily

that impacts only what the default should be, not whether the patch
should be in at all.

 > - patents are a tiny part of the process anyone shipping any software
 >   commercially on a scale worth lawsuits goes through reviewing.

so? For all the other parts of the process there are ways to manage
it. For patents, the solution of removing large amounts of
functionality is non-workable for many packages.

 > The patches you've proposed break stuff. It's mildly funny that MS is
 > trying to force us into a workaround that randomly crashes MS boxes but
 > that doesn't make it a good idea to merge such a change. Nor is it a good
 > idea to call something vfat which is not vfat.

and how is your preffered 'return -1/ENAMETOOLONG' for valid long
names 'vfat'? A new filesystem name could be used, but I think that is
largely cosmetic. How many Linux users, other than developers,
actually type:

  mount -t vfat .....

I think nearly all users just rely on the auto-detection of the fs
type. 

 > So instead of regressions can we be a little bit less clever and a little
 > bit more reliable and do "FAT which reads and honours existing longnames"
 > and give it a name other than vfat.
 > 
 > That would give us absolute on media compatibility, accessibility from
 > all devices (which is the important bit) but some naming limits for new
 > file creation.

It is the 'some naming limits' bit which is the problem. As was
pointed out when I posted the patch that did this in May, those limits
impact a whole lot of normal use cases.

Cheers, Tridge
