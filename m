Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0BLOf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:35:28 -0500
Received: from bamako.nerim.net ([62.4.17.28]:63392 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab0BLOf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:35:27 -0500
Date: Fri, 12 Feb 2010 15:35:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "H. Peter Anvin" <hpa@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, mirrors@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100212153522.39203cfa@hyperion.delvare>
In-Reply-To: <4B74832B.6050303@kernel.org>
References: <4B744E13.8040004@kernel.org>
	<20100211205129.GA26105@elf.ucw.cz>
	<4B74832B.6050303@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010 14:22:35 -0800, H. Peter Anvin wrote:
> It would also be "just weird" to:
> 
> a) require that the end user knows the particular compression format
> used by a particular legacy file.

While we're here... I think it is weird that the testing files for the
latest kernel are in testing/ directly, while the older ones have their
own subdirectory. I have a script which is greatly confused by this,
and I can imagine that other tools (for example ketchup) appreciate
this inconsistency moderately too. It is probably not ideal for mirrors
either... I don't know if the mirroring system is smart enough to deal
with file moves? If not then it generates useless traffic.

So I would like to propose that testing files are placed directly in
their final location. This would be both more consistent and easier
for everyone.

Thanks,
-- 
Jean Delvare
