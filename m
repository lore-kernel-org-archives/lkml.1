Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122Ab0A0Bc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0A0Bc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789Ab0A0Bc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:32:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726Ab0A0Bc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:32:26 -0500
Date: Tue, 26 Jan 2010 17:30:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@ZenIV.linux.org.uk>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [06/11] tty: fix race in tty_fasync
In-Reply-To: <20100126230402.GB24281@suse.de>
Message-ID: <alpine.LFD.2.00.1001261729510.24199@localhost.localdomain>
References: <20100126191624.538119758@mini.kroah.org> <m1bpggy7bt.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1001261357390.3574@localhost.localdomain> <20100126230402.GB24281@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Jan 2010, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> Subject: fnctl: f_modown should call write_lock_irqsave/restore

Ok, applied and pushed out as b04da8b, so you can add it to the -stable 
list.

		Linus
