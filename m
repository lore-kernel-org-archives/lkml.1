Return-Path: <linux-kernel-owner+w=401wt.eu-S1764586AbXKOQOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764586AbXKOQOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbXKOQOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:14:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56076 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758269AbXKOQOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:14:04 -0500
Date: Thu, 15 Nov 2007 08:11:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 08/16] skge: fix ram buffer size calculation
In-Reply-To: <20071115064037.GH18951@kroah.com>
Message-ID: <alpine.LFD.0.9999.0711150810130.2786@woody.linux-foundation.org>
References: <20071115060353.071060513@mini.kroah.org> <20071115064037.GH18951@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Nov 2007, Greg KH wrote:
> 
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Stephen Hemminger <shemminger@linux-foundation.org>
> 
> patch 7fb7ac241162dc51ec0f7644d4a97b2855213c32 in mainline.
> 
> This fixes problems with transmit hangs on older fiber based SysKonnect boards.
> 
> Adjust ram buffer sizing calculation to make it correct on all boards
> and make it like the code in sky2 driver.

This one is getting reverted in mainline in about five minutes (unless I 
find an email from Stephen to address the reported regression - I haven't 
gone through all my emails yet), so I don't think it should make it into 
stable.

			Linus
