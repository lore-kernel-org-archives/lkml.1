Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbXAaCkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbXAaCkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbXAaCkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:40:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34330 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435AbXAaCkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:40:15 -0500
Date: Tue, 30 Jan 2007 18:36:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: Adrian Bunk <bunk@stusta.de>, Bron Gondwana <brong@fastmail.fm>,
       Mike Houston <mikeserv@bmts.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How many people are using 2.6.16?
In-Reply-To: <45BFF1F4.3060401@rtr.ca>
Message-ID: <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org>
References: <45BE5948.6060403@redhat.com> <20070129160448.65fc63f3.mikeserv@bmts.com>
 <20070129221300.GC19422@brong.net> <20070130203933.GJ3754@stusta.de>
 <45BFF1F4.3060401@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Jan 2007, Mark Lord wrote:
> 
> I believe our featherless leader said he though it was an ancient bug,
> exasperated by something that went into 2.6.19.
> 
> If Linus's opinion is correct (still?), then the bug exists in all
> kernels since somewhere back in the 2.4.xx days.

The issue was somewhat confused by people certainly *reporting* it for 
older kernels. Also, as part of the dirty bit cleanups and sanity 
checkingwe did actually seem to fix a long-standing CIFS corruption (and 
apparently reisertfs/XFS problems too).

But the *common* case was actually introduced with 2.6.19, and 2.6.16 
wouldn't be affected. 

			Linus
