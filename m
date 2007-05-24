Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbXEXRTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbXEXRTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbXEXRS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:18:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34108 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802AbXEXRS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:18:57 -0400
Date: Thu, 24 May 2007 10:18:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       =?iso-8859-15?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
In-Reply-To: <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705241017010.29041@schroedinger.engr.sgi.com>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com>
 <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Linus Torvalds wrote:

> I'm going to change that "BUG:" to "WARNING:". 

Good. I wondered for a long time why a "WARN_xxx ... " does print BUG: 
xxx.
