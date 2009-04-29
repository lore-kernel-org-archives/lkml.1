Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbZD2SRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbZD2SRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbZD2SRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:17:14 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:35254 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZD2SRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LtXHthKv/FQ+Oagu7tpS3dL1FGdSaXuH9ZQ0QGAHVO8ml7XJPNBVGYxSYLXnAERmNc
         Df0Tx60s03vyxXicQS8NbJxbOL9R/SFrWWTICE+IQB4lhdXQu9ftCL1GEaw0EK/B7X6y
         DHRnauAcgSlegmD8EagP7TEZ019n+d85AphC0=
MIME-Version: 1.0
In-Reply-To: <20090429180735.GA29812@kroah.com>
References: <20090427193532.GA2948@kroah.com>
	 <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com>
	 <20090429180735.GA29812@kroah.com>
Date: Wed, 29 Apr 2009 14:17:12 -0400
Message-ID: <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
Subject: Re: usbutils 0.81 release
From: Mike Frysinger <vapier.adi@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 14:07, Greg KH wrote:
> On Wed, Apr 29, 2009 at 01:53:32PM -0400, Mike Frysinger wrote:
>> On Mon, Apr 27, 2009 at 15:35, Greg KH wrote:
>> > After over a year since the last release, I'd like to announce the
>> > release of usbutils 0.81.  It can be found at the traditionally horrible
>> > sf.net download page:
>> >        https://sourceforge.net/project/showfiles.php?group_id=3581
>> >
>> > We've switched over to using git for development now, which makes things
>> > much easier than the old cvs tree.  The tree can be found on both
>> > kernel.org and github.com if you want to fork it and send us changes
>> > easier:
>> >        http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
>> >        http://github.com/gregkh/usbutils/tree/master
>> >
>> > I've pushed all patches that were in the Gentoo and SuSE usbutils trees
>> > into this release.  If there are outstanding patches from other distros,
>> > I'd be very interested in getting them integrated in.
>>
>> looks like update-usbids.sh was forgotten from EXTRA_DIST in
>> Makefile.am so the released tarball doesnt have the script ;(
>
> Care to send a patch?
>
>> having to manually run `sed` on the scripts/man pages is annoying when
>> moving the ids file ... any chance of converting those to normal
>> configure generated files ?  or is there hard resistance to that ?
>
> No objection from me, have a patch?  :)

np, i'll send patches for both

>> i see `usbmodules` has been punted.  was there a reason for that ?
>
> It was for 2.4 kernels only.

that's a good reason :)

>> find being able to run `usbmodules` pretty useful ... i wrote a script
>> for fun:
>> http://sources.gentoo.org/sys-apps/usbutils/files/usbmodules.sh
>
> Did that work on any 2.6 kernel?

it's the only version ive tested it with ... but it doesnt parse any
kernel module directly, it reads the generated modules.usbmap file

> There's no reason we can't add "-k" support to lsusb like lspci has to
> show the modules assigned to different devices.

the method i posted above only needs the module to be compiled, not loaded
-mike
