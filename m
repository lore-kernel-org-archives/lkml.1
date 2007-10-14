Return-Path: <linux-kernel-owner+w=401wt.eu-S1763832AbXJNU7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763832AbXJNU7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759712AbXJNU7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:59:01 -0400
Received: from lucidpixels.com ([75.144.35.66]:58481 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759265AbXJNU7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:59:00 -0400
Date: Sun, 14 Oct 2007 16:58:58 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Al Viro <viro@ftp.linux.org.uk>
cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       apiszcz@solarrain.com
Subject: Re: In response to kernel compression e-mail a few months ago.
In-Reply-To: <20071014205008.GZ8181@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0710141650500.12466@p34.internal.lan>
References: <Pine.LNX.4.64.0710141533080.3935@p34.internal.lan>
 <Pine.LNX.4.64.0710142144340.22801@fbirervta.pbzchgretzou.qr>
 <20071014205008.GZ8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 14 Oct 2007, Al Viro wrote:

> On Sun, Oct 14, 2007 at 09:46:15PM +0200, Jan Engelhardt wrote:
>> (Obviously we shall pick .7z)
>
> The hell it is.  Take a look at memory footprint of those suckers...
>

For compression with -mx=9 it does use 500-900 MiB of RAM, that is true.
For decompression, 50-70 MiB.

Each have their pros/cons but nothing can compress the kernel any further 
than 7z, supports stdin/stdout and also has a native windows port.  I used 
to strictly use bzip2 for backups and such but if I can pick off an 
additional 20-30% more than bzip2 for my backups which I will not use often,
7zip seems to be the winner for space savings and possibly for 
bandwidth/cost savings..

compress:
   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
10544 war       20   0  700m 681m 1632 S  141 20.7   1:41.46 7z

decompress:
   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
11927 war       20   0 71256  66m 1536 R   88  2.0   0:04.07 7z

Justin.
