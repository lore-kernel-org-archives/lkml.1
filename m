Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYHROMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYHROMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYHROMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:12:36 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:37440 "EHLO
	QMTA07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbYHROMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:12:35 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2008 10:12:35 EDT
X-Authority-Analysis: v=1.0 c=1 a=6FoFWNeXg_0A:10 a=bqvuxQ9iNTUA:10
 a=6uN0qSChYthVbPp5lRIA:9 a=oi5cxhO3HUZU2DTKIvIA:7
 a=T-lDok-V0F-VMxRauXhP06t2jPYA:4 a=LY0hPdMaydYA:10
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access
	scanning
From: John Moser <nigelenki@comcast.net>
To: Eric Paris <eparis@redhat.com>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
In-Reply-To: <1217883616.27684.19.camel@localhost.localdomain>
References: <1217883616.27684.19.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 10:06:50 -0400
Message-Id: <1219068410.6361.151.camel@icebox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 17:00 -0400, Eric Paris wrote:
> Background
> ++++++++++
> There is a consensus in the security industry that protecting against
> malicious files (viruses, root kits, spyware, ad-ware, ...) by the way
> of so-called on-access scanning is usable and reasonable approach.
> Currently the Linux kernel does not offer a completely suitable
> interface to implement such security solutions.  Present solutions

A long time ago the FUSE developers said something about implementing
write-through stacking for FUSE (i.e. 'sudo fusermount -o allow_other
encfs / /' would allow mounting on /, and encfs could read/write under
its own mount point).

Wouldn't that make more sense?  You could i.e. edit /etc/avfs.conf to
say "scanner=clamscan" "clamscan=/usr/bin/clamscan" and mount avfs
on /...?

