Return-Path: <linux-kernel-owner+w=401wt.eu-S1760321AbZD2Rxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbZD2Rxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZD2Rxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:53:34 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:58648 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbZD2Rxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fd7M2fOOgbOGZFtnvoLj3UjEHWSx3D8Bcv6CHOsbPs6tqgNl0sg5XxbvUJ2xGpnuQo
         XIBEQROYlkzBFhEyZQ0GrSgGeR3r2WY7M84sC6BCAQoNzKrnQ/EBtZjpoVrGjDk6RXGa
         3PRgZVv4Z/Zs0jxfEAlDqGjwxSZBYMvDLNNWM=
MIME-Version: 1.0
In-Reply-To: <20090427193532.GA2948@kroah.com>
References: <20090427193532.GA2948@kroah.com>
Date: Wed, 29 Apr 2009 13:53:32 -0400
Message-ID: <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com>
Subject: Re: usbutils 0.81 release
From: Mike Frysinger <vapier.adi@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 15:35, Greg KH wrote:
> After over a year since the last release, I'd like to announce the
> release of usbutils 0.81.  It can be found at the traditionally horrible
> sf.net download page:
>        https://sourceforge.net/project/showfiles.php?group_id=3581
>
> We've switched over to using git for development now, which makes things
> much easier than the old cvs tree.  The tree can be found on both
> kernel.org and github.com if you want to fork it and send us changes
> easier:
>        http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
>        http://github.com/gregkh/usbutils/tree/master
>
> I've pushed all patches that were in the Gentoo and SuSE usbutils trees
> into this release.  If there are outstanding patches from other distros,
> I'd be very interested in getting them integrated in.

looks like update-usbids.sh was forgotten from EXTRA_DIST in
Makefile.am so the released tarball doesnt have the script ;(

having to manually run `sed` on the scripts/man pages is annoying when
moving the ids file ... any chance of converting those to normal
configure generated files ?  or is there hard resistance to that ?

i see `usbmodules` has been punted.  was there a reason for that ?  i
find being able to run `usbmodules` pretty useful ... i wrote a script
for fun:
http://sources.gentoo.org/sys-apps/usbutils/files/usbmodules.sh
-mike
