Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbXDCIZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbXDCIZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 04:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933192AbXDCIZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 04:25:05 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:59344 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbXDCIZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 04:25:03 -0400
Message-ID: <023901c775ca$1608d670$eeeea8c0@aldipc>
From: "roland" <devzero@web.de>
To: <lunz@falooley.org>, "Jeff Dike" <jdike@addtoit.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel release ?
Date: Tue, 3 Apr 2007 10:28:40 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-15";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2869
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

what is the real advantage to package uml-kernel and rootfs into a single 
file ?

If this needs to be distributed with additional script, that's two files, 
anyway.

the classical way would be 3 files:  uml-kernel, rootfs, script - put into 
some tar.gz or tar.bz2

this could look as elegant like:

linux-2.6.21-UML-TryMe-and-RunMe-Kit.tar.bz2

linux-2.6.21-start.sh  (containing ./linux-2.6.21-kernel-um 
ubd0=linux-2.6.21-rootfs.....)
linux-2.6.21-kernel-um
linux-2.6.21-rootfs

regards
roland

ps:
>I've done the converse: package the uml kernel within the rootfs image,
>and use a script that plays the part of bootloader. With ext2 at least,
>it's fairly easy to use the debugfs 'cat' command for this.
wicked, though! :)



On Mon, Apr 02, 2007 at 05:44:34PM -0400, Jeff Dike wrote:
> There are sites (http://uml.nagafix.co.uk/ being the best one I know
> of) where, with two downloads, two uncompressions, and one command
> line later, you have a booted UML.
>
> The only way I know of to improve on this, aside from inprovements in
> the booted distro, is to package the filesystem as a rootfs within the
> UML kernel binary.  I've considered this, but haven't done anything
> with it.

I've done the converse: package the uml kernel within the rootfs image,
and use a script that plays the part of bootloader. With ext2 at least,
it's fairly easy to use the debugfs 'cat' command for this.

That way, you simply distribute the fs image with a companion script
that can boot any number of such images.

Jason 

