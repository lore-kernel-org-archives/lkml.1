Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbZD2SK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbZD2SK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759317AbZD2SKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:10:37 -0400
Received: from kroah.org ([198.145.64.141]:60749 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758928AbZD2SKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:10:36 -0400
Date: Wed, 29 Apr 2009 11:07:35 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
Message-ID: <20090429180735.GA29812@kroah.com>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 01:53:32PM -0400, Mike Frysinger wrote:
> On Mon, Apr 27, 2009 at 15:35, Greg KH wrote:
> > After over a year since the last release, I'd like to announce the
> > release of usbutils 0.81.  It can be found at the traditionally horrible
> > sf.net download page:
> >        https://sourceforge.net/project/showfiles.php?group_id=3581
> >
> > We've switched over to using git for development now, which makes things
> > much easier than the old cvs tree.  The tree can be found on both
> > kernel.org and github.com if you want to fork it and send us changes
> > easier:
> >        http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
> >        http://github.com/gregkh/usbutils/tree/master
> >
> > I've pushed all patches that were in the Gentoo and SuSE usbutils trees
> > into this release.  If there are outstanding patches from other distros,
> > I'd be very interested in getting them integrated in.
> 
> looks like update-usbids.sh was forgotten from EXTRA_DIST in
> Makefile.am so the released tarball doesnt have the script ;(

Care to send a patch?

> having to manually run `sed` on the scripts/man pages is annoying when
> moving the ids file ... any chance of converting those to normal
> configure generated files ?  or is there hard resistance to that ?

No objection from me, have a patch?  :)

> i see `usbmodules` has been punted.  was there a reason for that ?

It was for 2.4 kernels only.

> find being able to run `usbmodules` pretty useful ... i wrote a script
> for fun:
> http://sources.gentoo.org/sys-apps/usbutils/files/usbmodules.sh

Did that work on any 2.6 kernel?

There's no reason we can't add "-k" support to lsusb like lspci has to
show the modules assigned to different devices.

thanks,

greg k-h
