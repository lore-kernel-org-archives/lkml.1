Return-Path: <linux-kernel-owner+w=401wt.eu-S1765035AbZBNBwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765035AbZBNBwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933349AbZBNBu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:50:56 -0500
Received: from ns.suse.de ([195.135.220.2]:58904 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbZBNBuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:50:55 -0500
Date: Fri, 13 Feb 2009 17:47:55 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH 1/9] Consolidate driver_probe_done() loops into one
	place
Message-ID: <20090214014755.GA17975@suse.de>
References: <200902140157.40869.rjw@sisk.pl> <200902140159.08252.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902140159.08252.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 01:59:06AM +0100, Rafael J. Wysocki wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> there's a few places that currently loop over driver_probe_done(), and
> I'm about to add another one. This patch abstracts it into a helper
> to reduce duplication.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Fine with me if this goes through Len's tree.

thanks,

greg k-h
