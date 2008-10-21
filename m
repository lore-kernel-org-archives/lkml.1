Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYJUPnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYJUPnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYJUPn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:43:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:23337 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYJUPnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kQXlKlOFNY3G5NrSjss+F4FyoxLemnBLO08/rHob0jo7cKKMAUKOcq408jQXIcvVOf
         V2VDaG1/QNqeonSZK5u1Bwmhs9BDhXK/MpbLo+6YjI3f1u5xKhkE0TH1xD2FXQFHSCLW
         Pe83OuFHfP+KVAI39Smi/kaeBJ2DpWD0uQFcE=
Message-ID: <9e4733910810210843v2b45d798xe8f448e75e5c2a6b@mail.gmail.com>
Date: Tue, 21 Oct 2008 11:43:25 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@ime.usp.br>,
       "Alexandre Lymberopoulos" <lymber@gmail.com>, 502583@bugs.debian.org,
       502583-submitter@bugs.debian.org, linux-kernel@vger.kernel.org,
       rafael@debian.org
Subject: Re: Bug#502583: scary messages in dmesg
In-Reply-To: <20081021153105.GD15685@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2bfaaf400810172145g4aba4827l87a19e67b9742815@mail.gmail.com>
	 <20081018060400.GB916@ime.usp.br>
	 <2bfaaf400810201654u21c9d950o72b2afa9496ba3da@mail.gmail.com>
	 <20081021101510.GA16244@ime.usp.br> <20081021123348.GB15685@mit.edu>
	 <20081021143500.GA18469@ime.usp.br> <20081021153105.GD15685@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 11:31 AM, Theodore Tso <tytso@mit.edu> wrote:
> Solving this problem for desktop users is harder; probably the best
> thing you can do is to throw up "shame" dialog box telling them that
> they did Something Wrong, and while they may have gotten lucky this
> time, that next time they should close all programs using the USB
> storage device, and then right-click on the mounted disk icon and
> select "eject".  That's what Windows does, and IIRC, what Mac OS X
> does; there really isn't much else that can be done.

Can we do something about atime on removable media? It is
non-intuitive to most users that sticking a drive in and copying a
couple files off from it is going to cause writes to the device. A
normal user would think that this is read-only access and it is ok to
yank the drive.  I've burnt myself several times from this.

Another thing that gets normal users is yanking out a drive that was
definitely idle and then not having the icon for the drive disappear
on the desktop.

Maybe change distro mount defaults for removable media to noatime? And
add an event when the drive is yanked with no pending writes to tell
the desktop the drive is gone?

Of course yanking with writes pending should generate a big error box.
Can it ask the user to reinsert the drive and pick up where it left
off?

-- 
Jon Smirl
jonsmirl@gmail.com
