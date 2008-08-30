Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYH3PZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYH3PZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 11:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYH3PZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 11:25:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:55098 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbYH3PZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 11:25:20 -0400
Date: Sat, 30 Aug 2008 08:25:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
Message-ID: <20080830082513.5fdc3c02@infradead.org>
In-Reply-To: <20080829193309.113d5b64@lxorguk.ukuu.org.uk>
References: <20080829080549.6906b744@infradead.org>
	<20080829080809.0e42a323@infradead.org>
	<alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org>
	<20080829171108.63e6dcd4@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0808291009450.3300@nehalem.linux-foundation.org>
	<20080829191837.3d2b3050@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0808291140010.3300@nehalem.linux-foundation.org>
	<20080829193309.113d5b64@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 19:33:09 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > And yes, I do agree that the heuristic could well involve other 
> > characteristics of the process in question. And probably
> > characteristics of the machine itself (ie some general kind of
> > "power mode" where timers are simply not considered critical if you
> > want to be in low-power mode).
> 
> HAL and dbus already deal with this sort of stuff, including now
> having a notion of 'on battery' and the like so if its in sysfs it
> ceases to be the kernels problem ;)

(side note: "on battery" is the worst possible measure for doing 'do I
need to be power sensitive', but you knew that already)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
