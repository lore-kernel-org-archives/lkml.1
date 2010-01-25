Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439Ab0AYRkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0AYRkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641Ab0AYRkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:40:07 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:60732 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab0AYRkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:40:04 -0500
Message-ID: <4B5DD76D.2050306@pardus.org.tr>
Date: Mon, 25 Jan 2010 19:39:57 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Xiaotian Feng <dfeng@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [00/29] 2.6.32.6 stable review
References: <20100123001145.GA7391@kroah.com> <20100123232152.4b88d1e3.akpm@linux-foundation.org> <alpine.LFD.2.00.1001241727560.2906@localhost.localdomain> <4B5D5903.4000209@pardus.org.tr> <20100125171631.GB17421@kroah.com>
In-Reply-To: <20100125171631.GB17421@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jan 25, 2010 at 10:40:35AM +0200, Ozan Çağlayan wrote:

> 
> Huh?  That says:
> 	clockevents: Add missing include to pacify sparse
> 
> and does not sound like a problem that needs to be fixed for "real"
> users, right?
> 
> Or does .32.6 have a build problem somewhere?

Applying the patch on top of 2.6.32.y causes build failure as the fix calls a macro from
"tick-internal.h".

#include "tick-internal.h"

was added to clockevents.c with 8e1a928a2ed7e8 in linux-2.6/master for another reason e.g.
the patch is OK for linux-2.6/master but should be modified to add #include directive
for .32.y when backporting.

Regards,
