Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZCZRMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZCZRMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbZCZRMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:12:12 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:49530 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbZCZRMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:12:12 -0400
From: Frans Pop <elendil@planet.nl>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, jack@suse.cz,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, a.p.zijlstra@chello.nl,
       npiggin@suse.de, jens.axboe@oracle.com, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, oleg@redhat.com,
       roland@redhat.com
Subject: Re: relatime: update once per day patches (was: ext3 IO latency measurements)
Date: Thu, 26 Mar 2009 17:53:09 +0100
User-Agent: KMail/1.9.9
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain> <20090326163026.GD6239@mit.edu>
In-Reply-To: <20090326163026.GD6239@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903261753.13323.elendil@planet.nl>
X-OriginalArrivalTime: 26 Mar 2009 17:12:09.0771 (UTC) FILETIME=[FF5F5FB0:01C9AE35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 March 2009, Theodore Tso wrote:
> I thought at least some distro's were adding relatime by default; I
> could be wrong, but I thought Ubuntu was doing this.  Personally, I
> actually think that if we're going to give up on POSIX, I'll go all
> the way to noatime since it helps even more.

They indeed do have relatime by default, but *only because* they have the 
additional patch with the 24 hour limit in their kernel [1]. The same is 
true for Fedora IIUC.

Debian would like to activate it by default as well for new installations, 
but has so far been blocked from doing that because our kernel team has a 
policy of not including patches that are not upstream (or at least, in 
the process of being included upstream). And the Debian Installer team 
has so far felt that it would be irresponsible of activating it by 
default without this safeguard.

Cheers,
FJP

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/199427
linux (2.6.24-12.18) hardy; urgency=low
[...]
  * build/configs: Enable relatime config option for all flavors
