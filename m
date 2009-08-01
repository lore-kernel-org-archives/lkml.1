Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbZHAAws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbZHAAws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 20:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZHAAws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 20:52:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbZHAAwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 20:52:47 -0400
Date: Fri, 31 Jul 2009 17:51:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, drepper@redhat.com, jens@mcbone.net,
       mingo@elte.hu, peterz@infradead.org, sonnyrao@us.ibm.com,
       stable@kernel.org, tglx@linutronix.de
Subject: Re: + execve-must-clear-current-clear_child_tid.patch added to -mm
 tree
Message-Id: <20090731175101.1699d653.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.01.0907311732250.3304@localhost.localdomain>
References: <200907312142.n6VLgKfx021454@imap1.linux-foundation.org>
	<20090731222959.GA8195@redhat.com>
	<alpine.LFD.2.01.0907311732250.3304@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 17:38:14 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sat, 1 Aug 2009, Oleg Nesterov wrote:
> > 
> > Perhaps it is better to change mm_release() ? It has to play with
> > ->clear_child_tid anyway.
> 
> Ahh. I take back my previous Ack. Your patch is better. I'll ack that 
> instead.
> 

'k, thanks.  I shall compulsively watch my inbox awaiting the signed-off
and tested version ;)
