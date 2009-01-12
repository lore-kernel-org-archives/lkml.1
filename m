Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbZALXRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbZALXRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZALXRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:17:30 -0500
Received: from tservice.ru ([195.178.208.66]:57472 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbZALXR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:17:29 -0500
Date: Tue, 13 Jan 2009 02:17:28 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112231728.GA23803@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk> <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496BCB7A.2010804@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 06:00:10PM -0500, Bill Davidsen (davidsen@tmr.com) wrote:
> >Being more serious, I agree that having a simple name does not solve the
> >problem if observed from any angle, but it is not the main goal.
> >Patch solves oom-killer selection issue from likely the most commonly
> >used case: when you know who should be checked and killed first when
> >problem appears.
> >
> The only cases in which this would really be useful is when running some 
> software which once in a great while goes super prompt critical and starts 
> throwing processes of a known name format in all directions, or when you 
> have a problem and know the process names involved before OOM kills 
> everything in sight.

Like anything that spawns a thread or process per request/client, or
preallocates set of them which connect to the huge object like database.
Most of the time database/server is killed first instead of comparably
small clients. In some cases it is possible to tune the environment, in
others it is not that simple. This patch works for such situatons
perfectly and does not require additional administrative burden, since
it does not make thinge worse as a whole, but only better for the very
commonly used cases, that's why I propose it for inclusion.

-- 
	Evgeniy Polyakov
