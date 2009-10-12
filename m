Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZJLKv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZJLKv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZJLKv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:51:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302AbZJLKvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:51:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091009161042.b301700c.randy.dunlap@oracle.com>
References: <20091009161042.b301700c.randy.dunlap@oracle.com> <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mmotm] synchro-test: add missing header file
Date: Mon, 12 Oct 2009 11:51:18 +0100
Message-ID: <23768.1255344678@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build errors, add <sched.h> header file:
> 
> kernel/synchro-test.c: In function 'sched':
> kernel/synchro-test.c:220: error: implicit declaration of function 'schedule'
> kernel/synchro-test.c: In function 'mutexer':
> kernel/synchro-test.c:227: error: implicit declaration of function 'daemonize'
> kernel/synchro-test.c:228: error: implicit declaration of function 'set_user_nice'
> kernel/synchro-test.c:241: error: dereferencing pointer to incomplete type
> kernel/synchro-test.c: In function 'semaphorer':
> kernel/synchro-test.c:263: error: dereferencing pointer to incomplete type
> kernel/synchro-test.c: In function 'reader':
> kernel/synchro-test.c:287: error: dereferencing pointer to incomplete type
> kernel/synchro-test.c: In function 'writer':
> kernel/synchro-test.c:311: error: dereferencing pointer to incomplete type
> kernel/synchro-test.c: In function 'downgrader':
> kernel/synchro-test.c:340: error: dereferencing pointer to incomplete type
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: David Howells <dhowells@redhat.com>
