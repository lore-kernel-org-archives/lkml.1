Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbXCTQKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbXCTQKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934014AbXCTQKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:10:00 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44802 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbXCTQJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:09:59 -0400
Date: Tue, 20 Mar 2007 08:09:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, pavel@suse.cz, linux-pm@lists.osdl.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070320080944.9cb3c765.akpm@linux-foundation.org>
In-Reply-To: <45FFF026.4030502@gmail.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<45FFF026.4030502@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 15:31:02 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> Andrew Morton napsal(a):
> >   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> I'm getting this while trying to swsusp:
> Stopping tasks ...
> Stopping kernel threads timed out after 20 seconds (1 tasks refusing to freeze):
>  swapper
>  Restarting tasks ... done.
> 
> What to test? Enable PM_DEBUG?

hm, OK.  Rafael has been working on fixing the process freezer and it'll
take some time to get it to where we want it to be, I expect.

Rafael, I think that we could afford to add heaps of debug in there at this
stage to help us track down problems like this.

Also, it might be useful to add a temporary /proc/freeze-unfreeze thing
which will simply do a freeze/unfreeze cycle.  Then we can apply various
workloads to the machine while madly stressing the freezer code.  
