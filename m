Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab0BLTcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:32:14 -0500
Received: from bamako.nerim.net ([62.4.17.28]:54959 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488Ab0BLTcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:32:12 -0500
Date: Fri, 12 Feb 2010 20:32:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100212203209.0cb8afc3@hyperion.delvare>
In-Reply-To: <4B75A5CF.70308@lougher.demon.co.uk>
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<4B75A5CF.70308@lougher.demon.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 19:02:39 +0000, Phillip Lougher wrote:
> 5* Archive all the older 2.6.x files and move them into a separate
>     directory (e.g. v2.6-pre20).  Moving all the pre 2.6.20 files
>     saves 42% of the file listing.
> 
> This seems an obvious solution, what am I missing?

This is confusing, inconsistent and unstable. Confusing because 2.6-pre
referred so far to the releases immediately preceding 2.6.0.
Inconsistent because it requires the downloader to have preliminary
knowledge about what the break point is. Unstable because, while you
consider pre20 to qualify as "old" today, in 5 years you will want
pre30 to qualify as "old" instead, meaning that tools such as ketchup
would have to be updated once again.

I think we want to come up with a directory structure which won't change
in the future.

-- 
Jean Delvare
