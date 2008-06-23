Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYFWDdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYFWDdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYFWDc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:32:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40575 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbYFWDc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:32:56 -0400
Date: Sun, 22 Jun 2008 20:25:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Documentation cleanup: trivial misspelling,
 punctuation, and grammar corrections.
Message-Id: <20080622202539.f302ce03.randy.dunlap@oracle.com>
In-Reply-To: <1214020821-19361-1-git-send-email-kernel1@cyberdogtech.com>
References: <1214020821-19361-1-git-send-email-kernel1@cyberdogtech.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 23:00:21 -0500 Matt LaPlante wrote:

Signed-off-by: ??

A few nits below...

> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index b7522c6..c4d348d 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -895,9 +895,9 @@ struct dentry_operations {
>  	iput() yourself
>  
>    d_dname: called when the pathname of a dentry should be generated.
> -	Usefull for some pseudo filesystems (sockfs, pipefs, ...) to delay
> +	Useful for some pseudo filesystems (sockfs, pipefs, ...) to delay
>  	pathname generation. (Instead of doing it when dentry is created,
> -	its done only when the path is needed.). Real filesystems probably
> +	it's done only when the path is needed.). Real filesystems probably
>  	dont want to use it, because their dentries are present in global

	don't

>  	dcache hash, so their hash should be an invariant. As no lock is
>  	held, d_dname() should not try to modify the dentry itself, unless

> diff --git a/Documentation/sound/alsa/Audiophile-Usb.txt b/Documentation/sound/alsa/Audiophile-Usb.txt
> index 2ad5e63..a4c53d8 100644
> --- a/Documentation/sound/alsa/Audiophile-Usb.txt
> +++ b/Documentation/sound/alsa/Audiophile-Usb.txt
> @@ -388,9 +388,9 @@ There are 2 main potential issues when using Jackd with the device:
>  
>  Jack supports big endian devices only in recent versions (thanks to
>  Andreas Steinmetz for his first big-endian patch). I can't remember 
> -extacly when this support was released into jackd, let's just say that 
> +exactly when this support was released into jackd, let's just say that
>  with jackd version 0.103.0 it's almost ok (just a small bug is affecting 
> -16bits Big-Endian devices, but since you've read  carefully the above 
> +16bits Big-Endian devices, but since you've read carefully the above

   16-bit (above and below here)

>  paragraphs, you're now using kernel >= 2.6.23 and your 16bits devices 
>  are now Little Endians ;-) ).
>  

Thanks.  Big ack for all of the others.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
