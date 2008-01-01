Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbYAAXVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbYAAXVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYAAXVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:21:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbYAAXVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:21:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on x86-64 (rev. 2)
Date: Wed, 2 Jan 2008 00:23:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
References: <200712302313.52483.rjw@sisk.pl> <20080102000222.GA2404@ucw.cz>
In-Reply-To: <20080102000222.GA2404@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801020023.58040.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of January 2008, Pavel Machek wrote:
> On Sun 2007-12-30 23:13:51, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Document the fact that __save_processor_state() has to save all CPU
> > registers referred to by the kernel in case a different kernel is
> > used to load and restore a hibernation image containing it. 
> > 
> > Sigend-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ACK.

Thanks!

Ingo, can you please take this patch for 2.6.25 or should I forward it to Len?

Rafael
