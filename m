Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYLCAGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYLCAGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYLCAGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:06:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43767 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbYLCAGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:06:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Wed, 3 Dec 2008 01:05:53 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812021518160.3256@nehalem.linux-foundation.org> <200812030100.18400.rjw@sisk.pl>
In-Reply-To: <200812030100.18400.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812030105.53529.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 3 of December 2008, Rafael J. Wysocki wrote:
> On Wednesday, 3 of December 2008, Linus Torvalds wrote:
> > 
> > So are you saying that the unpatched kernel still reliably doesn't 
> > hibernate for you, while the (arguably _incorrect_) patched kernel 
> > reliably does hibernate?
> 
> Yes, I am.

To be more precise, the patched kernel resumes reliably (100% of the time)
while the plain -rc7 doesn't.  Both hibernate (ie. create the image and save
it) reliably.

Thanks,
Rafael
