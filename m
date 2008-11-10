Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYKJDAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYKJDAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 22:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYKJDAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 22:00:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44463 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbYKJDAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 22:00:30 -0500
Message-ID: <4917A31F.6060903@redhat.com>
Date: Mon, 10 Nov 2008 10:57:35 +0800
From: Eugene Teo <eteo@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       ext4 development <linux-ext4@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>, Eugene Teo <eugeneteo@kernel.sg>
Subject: Re: [patch 02/16] ext: Avoid printk floods in the face of directory
 corruption (CVE-2008-3528)
References: <20081107231848.995297975@mini.kroah.org> <20081107232601.GC4282@kroah.com>
In-Reply-To: <20081107232601.GC4282@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Likewise, please change the description to:

"A very large directory with many read failures (either due to storage
problems, or due to invalid size & blocks from corruption) will generate
a printk storm as the filesystem continues to try to read all the
blocks. This flood of messages can tie up the box until it is complete -
which may be a very long time, especially for very large corrupted values.

This is fixed by only reporting the corruption once each time we try to
read the directory."

Thanks, Eugene
