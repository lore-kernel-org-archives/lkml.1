Return-Path: <linux-kernel-owner+w=401wt.eu-S1764231AbYF3TyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764231AbYF3TyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYF3TyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:54:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbYF3TyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:54:06 -0400
Date: Mon, 30 Jun 2008 12:52:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott Wiersdorf <scott@bluehost.com>
Cc: andi@firstfloor.org, balbir@in.ibm.com, linux-kernel@vger.kernel.org,
       matt@bluehost.com
Subject: Re: [PATCH 2.6.25-4] getdelays.c: signal handling for log rotation
Message-Id: <20080630125254.3c9f81fd.akpm@linux-foundation.org>
In-Reply-To: <20080606204704.GA4330@perlcode.org>
References: <20080605194334.GA56830@perlcode.org>
	<87d4muu0k2.fsf@basil.nowhere.org>
	<20080606204704.GA4330@perlcode.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 14:47:04 -0600
Scott Wiersdorf <scott@bluehost.com> wrote:

> On Fri, Jun 06, 2008 at 03:59:09PM +0200, Andi Kleen wrote:
> > Scott Wiersdorf <scott@perlcode.org> writes:
> > 
> > > This adds a USR1 signal handler to getdelays.c, which causes getdelays
> > > to close its logfile and reopen it (if '-w logfile' is
> > > specified). This is useful in situations when getdelays is running for
> > > a long time (i.e, the log file growing) and you need to rotate the
> > > logs but don't want to lose any log data.
> > 
> > You could do the same by sending SIGSTOP; copy file; truncate file; SIGCONT
> 
> Actually, I was wrong in my previous reply. Sorry for my error. The
> above will work fine (no data loss; I guess the data queues somewhere
> in some magic way?)
> 
> I still think a single handler is elegant enough though, and works
> better with many log rotation systems that want to send a single
> signal to a pid (it's what we need where I'm working now, hence the
> patch).
> 

I've somewhat lost track of the discussion here.  Could you please send
a new patch which reflects the changes whcih you decided to make?

Thanks.
