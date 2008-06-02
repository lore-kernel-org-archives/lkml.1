Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYFBQH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYFBQH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYFBQHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:07:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43889 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbYFBQHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:07:15 -0400
Message-ID: <48441AA6.8080704@garzik.org>
Date: Mon, 02 Jun 2008 12:07:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Theodore Tso <tytso@mit.edu>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
References: <20080508161008.59361de5@appleyard>	<20080527030854.GC7515@mit.edu>	<20080527143202.4bab5bf0@appleyard>	<20080527225926.GE6843@mit.edu>	<20080527163251.04054a74@appleyard>	<20080531080015.GG5405@ucw.cz>	<4842F5A8.9020708@garzik.org> <20080602080440.25fc663c@core> <4843A4A7.3020809@garzik.org> <4843EF88.2040606@rtr.ca>
In-Reply-To: <4843EF88.2040606@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> For the power-off of unused ports, the current patch still sounds
> extremely vendor-specific (Intel).
> 
> Does it actually work (demonstrate, please) on any other hardware ?

Ding...  correct.  We need something per-port that's not Intel specific.

	Jeff



