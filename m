Return-Path: <linux-kernel-owner+w=401wt.eu-S1767565AbXEDHS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767565AbXEDHS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767588AbXEDHS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:18:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767565AbXEDHSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:18:54 -0400
Date: Fri, 4 May 2007 00:18:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Power Management: use mutexes instead of semaphores
Message-Id: <20070504001848.94d9b749.akpm@linux-foundation.org>
In-Reply-To: <20070504070840.GD3234@traven>
References: <20070427083857.GB4213@traven>
	<20070427084322.GC4213@traven>
	<20070503225432.97dad06e.akpm@linux-foundation.org>
	<20070504070840.GD3234@traven>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 09:08:40 +0200 Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:

> > I note that none of these patches added a #include <linux/mutex.h>.  Each C
> > file which uses mutexes should do that, rather than relying upon accidental
> > nested includes.  I hope you're checking for that.
> 
> initially i added the include line (i think at least one patch still
> contains it), but then i realized that in most cases the original code
> doesn't include semaphore.h and i (mis-)interpreted that it should be
> handled the same way (relying upon nested includes) for mutexes. 
> 
> do you want me to send you a version of the patches containing the
> include?

erm, is OK, I'll make the changes.
