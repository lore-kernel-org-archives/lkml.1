Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZHAAjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZHAAjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 20:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZHAAjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 20:39:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905AbZHAAjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 20:39:54 -0400
Date: Fri, 31 Jul 2009 17:38:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, drepper@redhat.com, jens@mcbone.net,
       mingo@elte.hu, peterz@infradead.org, sonnyrao@us.ibm.com,
       stable@kernel.org, tglx@linutronix.de
Subject: Re: + execve-must-clear-current-clear_child_tid.patch added to -mm
 tree
In-Reply-To: <20090731222959.GA8195@redhat.com>
Message-ID: <alpine.LFD.2.01.0907311732250.3304@localhost.localdomain>
References: <200907312142.n6VLgKfx021454@imap1.linux-foundation.org> <20090731222959.GA8195@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 1 Aug 2009, Oleg Nesterov wrote:
> 
> Perhaps it is better to change mm_release() ? It has to play with
> ->clear_child_tid anyway.

Ahh. I take back my previous Ack. Your patch is better. I'll ack that 
instead.

		Linus
