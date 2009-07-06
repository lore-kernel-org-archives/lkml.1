Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZGFVIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZGFVIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZGFVIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:08:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39765 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZGFVIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:08:42 -0400
Date: Mon, 6 Jul 2009 23:08:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jamie Lokier <jamie@shareable.org>
cc: tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <20090706205844.GE13638@shareable.org>
Message-ID: <alpine.LSU.2.00.0907062304310.31166@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr> <19021.26102.80885.330380@samba.org> <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr> <19021.31291.642416.956966@samba.org> <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>
 <19021.63615.450348.192109@samba.org> <alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr> <19025.63119.656216.431469@samba.org> <alpine.LSU.2.00.0907061932120.20434@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
 <20090706205844.GE13638@shareable.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-07-06 22:58, Jamie Lokier wrote:
>> On Monday 2009-07-06 20:55, Jan Engelhardt wrote:
>> >>How did things go with your mp3 players?
>> >[...]
>> >As it stands, my two devices always want a valid 8.3 name.
>> 
>> On or about June 26, James Bottomley exchanged these words to Andrew Tridgell:
>> >So the patch has been tested with Vista, Windows 7 and Windows XP
>> 
>> [Test with Windows 98, and 16-bit GDI programs under XP]
>> [3] http://picpaste.de/w98dualnames.png
>> [4] http://picpaste.de/xpwith16bit.png
>> (pics kept for 7 days from now)
>
>Summary of pics, for posterity:
>[3] shows an [...] Question: In Windows 98, is it just the MS-DOS box
>which cannot see some of the filenames, or is the normal file explorer
>affected too?

[3] shows an MS-DOS window on a Win98 desktop, having just run the
"dir" command. In the background is a Win98 explorer window, for
comparison with the dir command.
Neither of the two ways of listing the contents of a directory show
any filenames for <illegal 8.3, long name present> entries as produced
by tridge's vfat patches.

>[4] shows a old-looking Windows application, presumably 16-bit running
>    on XP, with a File Selection box listing the a:\ drive.  Four
>    files are shown on the a:\ drive in a selection box, but the first
>    of them is completely blank.

As the filename and the intro text had said..

[4] 16-bit program (Windows 3.x era) running on XP (but probably also
happens earlier). File dialog shows blank line where an entry has an
illegal 8.3 name; also as a result of the vfat aptches.
