Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZKBRwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZKBRwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbZKBRwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:52:41 -0500
Received: from relais.videotron.ca ([24.201.245.36]:43493 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbZKBRwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:52:40 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 02 Nov 2009 12:51:12 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Cox <alan@linux.intel.com>
Cc: linux-mmc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com
Subject: Re: [PATCH 0/6] Clean up the sdio_uart driver and fix the tty code
In-reply-to: <20091102164039.11877.88825.stgit@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0911021243040.13333@xanadu.home>
References: <20091102164039.11877.88825.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, Alan Cox wrote:

> This sorts out the sdio uart handling of the tty layer. The existing code
> has lots of races and other fun bugs. Beat it into the current tty format for
> hotpluggable devices. The updates are intentionally modelled on Alan Stern's
> USB serial approach which is defintiely "best practice" right now. Also clean
> it up as we go and sort the circ stuff out.

Thanks.

> I don't have hardware to test this so hopefully someone out there does,
> otherwise given the nature of the bugs involved the driver will be progressed
> to BROKEN and removal.

I still have the hardware.  Even tested it recently with a new SDIO host 
controller and it "worked just fine".  Hardware is a GPS receiver so 
admitedly nothing that would push this driver into corner cases.

However I have problems applying your patches.  Most of them require 
fuzzy patching to apply, and one of them even doesn't apply that way.  
What is your base tree?


Nicolas
