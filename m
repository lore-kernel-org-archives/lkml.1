Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0BNJca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:32:30 -0500
Received: from poutre.nerim.net ([62.4.16.124]:59657 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab0BNJc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:32:28 -0500
Date: Sun, 14 Feb 2010 10:32:26 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, lasse.collin@tukaani.org,
       mirrors@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       users@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100214103226.64736ce5@hyperion.delvare>
In-Reply-To: <4B7729B5.4040609@lougher.demon.co.uk>
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<4B75A5CF.70308@lougher.demon.co.uk>
	<20100212203209.0cb8afc3@hyperion.delvare>
	<4B75B2A6.5080006@lougher.demon.co.uk>
	<20100212225923.36a67112@hyperion.delvare>
	<4B75E6C7.5030106@lougher.demon.co.uk>
	<20100213083115.5cf8d4a4@hyperion.delvare>
	<4B7729B5.4040609@lougher.demon.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip,

On Sat, 13 Feb 2010 22:37:41 +0000, Phillip Lougher wrote:
> Embedded and enterprise distro users are usually stuck on ancient kernels that
> were downloaded from kernel.org and patched *years ago*.  The reason they're
> stuck on them is due to local modifications, and so they're not going to be
> downloading ancient vanilla kernels from kernel.org now.

They perfectly could. This is exactly what we're doing at Suse and I can
easily imagine other companies follow the same model. We store our
local changes as patches on top of the old kernel version. When a new
developer joins the team and needs to setup a working tree, our setup
script gets the patches from our internal repository, fetches the
relevant kernel tarball from kernel.org, unpacks it and applies all the
patches.

This is one of the reasons why others have been claiming in this
discussion: it would be weird if files which were previously available
would suddenly disappear. We can discuss the cost and benefits of any
change done to the tree structure, compression formats etc. but please
do not assume that nobody is downloading the old files from kernel.org.

Personally I wouldn't mind at all if old files would disappear and our
tools have to be adjusted accordingly, as long as it happens only once
in a long while and not on a regular basis by (broken) design.

-- 
Jean Delvare
