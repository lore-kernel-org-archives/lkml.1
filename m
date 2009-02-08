Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZBHKRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZBHKRK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 05:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZBHKQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 05:16:56 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:51527 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZBHKQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 05:16:55 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0902070837350.3048@localhost.localdomain>
References: <1233937349.17551.18.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0902060851270.3048@localhost.localdomain>
	 <1233957067.10366.0.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0902061358070.3048@localhost.localdomain>
	 <1233965457.10366.11.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0902070837350.3048@localhost.localdomain>
Date: Sun, 8 Feb 2009 11:16:53 +0100
Message-ID: <ac3eb2510902080216k55d525dam68aefeb0b45257ab@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.29-rc
From: Kay Sievers <kay.sievers@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 7, 2009 at 17:37, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, 6 Feb 2009, Chris Mason wrote:
>>
>> Crud, the confusion would be me.  I missed the cleanups and bug fixes
>> between 2.6.29-rc1 and rc3.   The correct diffstat and short log are
>> below, and the only non-btrfs change is to the MAINTAINERS file.
>
> Ok.
>
> I notice that it now asks about ACL's, and says
>
>        If you don't know what Access Control Lists are, say N
>
> which is all fine, but last I saw some (most?) distributions use POSIX
> ACL's for things like desktop access permissions to /dev/audio etc.
>
> I don't particularly have to like it, but it does mean that if you don't
> do POSIX ACL's, and have btrfs as your root filesystem, you'll quite
> likely not get sound when logging in.
>
> I dunno. I haven't actually yet tried to convert my laptop, so I just
> reacted to this thanks to the new question..

Systems using ACLs to grant device permissions to logged-in users have
/dev on a tmpfs mount, where the content will not survive a reboot.
This should not be a problem for btrfs, or the rootfs fs type, but
TMPFS_POSIX_ACL. Maybe we want to have a comment there?

Thanks,
Kay
