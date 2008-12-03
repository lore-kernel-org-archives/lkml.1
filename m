Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYLCAhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYLCAhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYLCAh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:37:26 -0500
Received: from metal.x2a.org ([206.248.189.157]:41359 "EHLO metal.x2a.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYLCAhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:37:25 -0500
Message-ID: <4935D4C0.7050601@x2a.org>
Date: Tue, 02 Dec 2008 19:37:20 -0500
From: Jonathan Bastien-Filiatrault <joe@x2a.org>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Andres Freund <andres@anarazel.de>,
       Andreas Dilger <adilger@sun.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: EXT4 ENOSPC Bug
References: <200811291418.24672.andres@anarazel.de> <200812021559.05103.andres@anarazel.de> <20081202164709.GC18162@mit.edu> <200812021847.35771.andres@anarazel.de> <20081202203315.GA20858@mit.edu>
In-Reply-To: <20081202203315.GA20858@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:

> Hmm...  really?  Was the error message ENOSPC, or something else?
>
I can confirm I get a ENOSPC on open/creat. Here is the relevant output
from strace touch test:

open("test", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK, 0666) = -1 ENOSPC (No
space left on device)

And the df -h output (first filesystem in list):

Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/vg0-root   88G   60G   25G  71% /
tmpfs                 1.6G   12K  1.6G   1% /lib/init/rw
udev                   10M  112K  9.9M   2% /dev
tmpfs                 1.6G     0  1.6G   0% /dev/shm
/dev/sda1              92M   19M   69M  22% /boot
none                  1.6G  3.3M  1.6G   1% /tmp

Cheers,
Jonathan
