Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZBGQiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZBGQiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 11:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZBGQh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 11:37:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291AbZBGQh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 11:37:58 -0500
Date: Sat, 7 Feb 2009 08:37:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Mason <chris.mason@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates for 2.6.29-rc
In-Reply-To: <1233965457.10366.11.camel@think.oraclecorp.com>
Message-ID: <alpine.LFD.2.00.0902070837350.3048@localhost.localdomain>
References: <1233937349.17551.18.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0902060851270.3048@localhost.localdomain>  <1233957067.10366.0.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0902061358070.3048@localhost.localdomain>
 <1233965457.10366.11.camel@think.oraclecorp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 6 Feb 2009, Chris Mason wrote:
> 
> Crud, the confusion would be me.  I missed the cleanups and bug fixes
> between 2.6.29-rc1 and rc3.   The correct diffstat and short log are
> below, and the only non-btrfs change is to the MAINTAINERS file.

Ok.

I notice that it now asks about ACL's, and says

	If you don't know what Access Control Lists are, say N

which is all fine, but last I saw some (most?) distributions use POSIX 
ACL's for things like desktop access permissions to /dev/audio etc.

I don't particularly have to like it, but it does mean that if you don't 
do POSIX ACL's, and have btrfs as your root filesystem, you'll quite 
likely not get sound when logging in.

I dunno. I haven't actually yet tried to convert my laptop, so I just 
reacted to this thanks to the new question..

		Linus
