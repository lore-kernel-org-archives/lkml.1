Return-Path: <linux-kernel-owner+w=401wt.eu-S1763683AbXKNUgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763683AbXKNUgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbXKNUg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:36:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760549AbXKNUg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:36:27 -0500
Date: Wed, 14 Nov 2007 12:36:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
Message-Id: <20071114123619.9c058a44.akpm@linux-foundation.org>
In-Reply-To: <473B5987.60904@gmail.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<473B5987.60904@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 21:24:39 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> On 11/14/2007 02:59 AM, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/
> 
> Doesn't suspend for me (neither broken-out-2007-11-13-04-14 did) on x86_64.
> echo mem >/sys/power/state
> causes shut down of disk(s) and blinking cursor on 1,1 position.
> The last working was 2.6.23-rc8-mm2. I haven't tested
> 2.6.23-mm1, since it didn't work for me.
> 
> As usual, I don't know how to debug this and what other info is needed, any
> thoughts?
> 

http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt
would be ideal, please.  It's pretty quick.  I did it about six times
yesterday evening :(
