Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZGAIEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZGAIEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZGAIEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:04:37 -0400
Received: from mail.opencsw.org ([147.87.98.73]:61343 "EHLO mail.opencsw.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZGAIEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:04:34 -0400
Date: Wed, 1 Jul 2009 10:04:32 +0200
From: Attila Kinali <attila@kinali.ch>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Long lasting MM bug when swap is smaller than RAM
Message-Id: <20090701100432.2d328e46.attila@kinali.ch>
In-Reply-To: <4A4ABD8F.40907@gmail.com>
References: <20090630115819.38b40ba4.attila@kinali.ch>
	<4A4ABD8F.40907@gmail.com>
Organization: GEHIRN
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 19:36:15 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> On 06/30/2009 03:58 AM, Attila Kinali wrote:
> > Moin,
> >
> > There has been a bug back in the 2.4.17 days that is somehow
> > triggered by swap being smaller than RAM, which i thought had
> > been fixed long ago, reappeared on one of the machines i manage.
> >
> > <history>
> 
> It's quite unlikely what you are seeing is at all related to that 
> problem. The VM subsystem has been hugely changed since then.

That's why i thought this problem was fixed.

> You didn't post what the swap usage history before the upgrade was. 

Because i don't have any hard data on this. I checked it by hand
from time to time and we never had more than a few MB of swap used.

> But 
> swapping does not only occur if memory is running low. If disk usage is 
> high then non-recently used data may be swapped out to make more room 
> for disk caching.

Hmm..I didn't know this.. thanks!

 
> Also, by increasing memory from 2GB to 6GB on a 32-bit kernel, some 
> memory pressure may actually be increased since many kernel data 
> structures can only be in low memory (the bottom 896MB).

Interesting. But shouldnt memory be "swapped" to highmem first
before going out onto disk?

> The more that 
> the system memory is increased the more the pressure on low memory can 
> become. Using a 64-bit kernel avoids this problem.

Unfortunately, the CPU we have is still a pure 32bit CPU, so this option
cannot be used.

			Attila Kinali
