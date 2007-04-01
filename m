Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbXDACwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbXDACwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 22:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbXDACwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 22:52:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:45927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXDACwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 22:52:37 -0400
Date: Sat, 31 Mar 2007 19:52:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aaron Lehmann <aaronl@vitelus.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Silent corruption on AMD64
Message-Id: <20070331195236.7c818ed5.akpm@linux-foundation.org>
In-Reply-To: <20070401012736.GT15189@vitelus.com>
References: <20070401012736.GT15189@vitelus.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 31 Mar 2007 18:27:36 -0700 Aaron Lehmann <aaronl@vitelus.com> wrote:
> I have spent a lot of time trying to find a simpler test case. So far,
> as far as I can tell, there are three conditions that must be
> satisfied for corruption to occur:
> 
> 1. Heavy Ethernet load (nc remotehost < /dev/zero)
> 2. Heavy disk write load on any non-sata_sil drive (cat /dev/zero > /path)
> 3. Heavy disk read load on any other drive (tar c /path | cat > /dev/null)
> 
> With these conditions satisfied, data read off sda or sdb (the drives
> associated with sata_sil) is often corrupted. Since I can only see
> this problem with files on those two drives, I'm inclined to suspect
> the sata_sil driver, but I really have no idea what's going on. I know
> this is not a recent issue - I experienced very similar corruption at
> least a year ago. I wasn't able to reproduce it at the time, because
> it only appeared in the backups I was restoring from.

Are you able to provide us with some before-and-after data so we
can see this corruption.

See, if it's dropped-bits or shifted-data or eight-byte-aligned
kernel addresses or whatever, that helps us generate theories..
