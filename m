Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbXLJTqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbXLJTqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbXLJTq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:46:29 -0500
Received: from brick.kernel.dk ([87.55.233.238]:19080 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbXLJTq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:46:28 -0500
Date: Mon, 10 Dec 2007 20:46:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: Re: syslets v7: back to basics
Message-ID: <20071210194623.GL22445@kernel.dk>
References: <1196983219534-git-send-email-zach.brown@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196983219534-git-send-email-zach.brown@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06 2007, Zach Brown wrote:
> 
> The following patches are a substantial refactoring of the syslet code.  I'm
> branding them as the v7 release of the syslet infrastructure, though they
> represent a signifiant change in focus.

[snip]

In case anyone is interested in playing with this, I updated the fio
syslet engine to this interface. Not very well tested yet, but it seems
to work.

I have to say that I like the new interface a lot better, it's a lot
simpler to work with. I was able to cut about 33% of the code that
handles queueing IO and retrieving events (maybe even more, summed up
losely). I'm still not a big fan of the indirect stuff, but that's
minor.

You can get fio by doing a

$ git clone git://git.kernel.dk/fio.git

or just grabbing the latest snapshot from

http://brick.kernel.dk/snaps/fio-git-latest.tar.gz

-- 
Jens Axboe

