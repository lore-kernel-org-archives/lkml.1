Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbXEYRJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbXEYRJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXEYRJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:09:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbXEYRJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:09:02 -0400
Message-ID: <465717BE.6070102@redhat.com>
Date: Fri, 25 May 2007 13:07:10 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Newport <crn@netunix.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com> <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org> <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org> <20070525101105.GA9268@elte.hu> <4656CE39.8050800@netunix.com> <alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2007 12:45 PM, Linus Torvalds wrote:
> Yes, in a controlled environment, dumping the whole memory image to disk 
> may be the right thing to do. BUT: in a controlled environment, you'll 
> never get the kind of usage that Linux gets. Why do you think Linux (and 
> Windows, for that matter) took away a lot of the market from traditional 
> UNIX? 
> 

Windows can dump memory to the swap file on crash. Default is a "minidump"
IIRC but you can set it to dump all memory (or none.)

