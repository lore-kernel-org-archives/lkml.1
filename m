Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbZJLXVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbZJLXVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933561AbZJLXVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:21:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933264AbZJLXVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:21:19 -0400
Date: Mon, 12 Oct 2009 16:20:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mmotm] synchro-test: add missing header file
Message-Id: <20091012162015.9cc24569.akpm@linux-foundation.org>
In-Reply-To: <23768.1255344678@redhat.com>
References: <20091009161042.b301700c.randy.dunlap@oracle.com>
	<200910090830.n998Ubvv020464@imap1.linux-foundation.org>
	<23768.1255344678@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 11:51:18 +0100
David Howells <dhowells@redhat.com> wrote:

> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix build errors, add <sched.h> header file:
> > 
> > kernel/synchro-test.c: In function 'sched':
> > kernel/synchro-test.c:220: error: implicit declaration of function 'schedule'
> > kernel/synchro-test.c: In function 'mutexer':
> > kernel/synchro-test.c:227: error: implicit declaration of function 'daemonize'
> > kernel/synchro-test.c:228: error: implicit declaration of function 'set_user_nice'
> > kernel/synchro-test.c:241: error: dereferencing pointer to incomplete type
> > kernel/synchro-test.c: In function 'semaphorer':
> > kernel/synchro-test.c:263: error: dereferencing pointer to incomplete type
> > kernel/synchro-test.c: In function 'reader':
> > kernel/synchro-test.c:287: error: dereferencing pointer to incomplete type
> > kernel/synchro-test.c: In function 'writer':
> > kernel/synchro-test.c:311: error: dereferencing pointer to incomplete type
> > kernel/synchro-test.c: In function 'downgrader':
> > kernel/synchro-test.c:340: error: dereferencing pointer to incomplete type
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Acked-by: David Howells <dhowells@redhat.com>

kernel/synchro-test.c has mysteriously vanished from linux-next so I
can't merge this and don't know who should.  Ingo, perhaps?

