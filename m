Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbYGUGmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbYGUGmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbYGUGmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:42:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757732AbYGUGmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:42:19 -0400
Date: Sun, 20 Jul 2008 23:42:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] lockd: trivial sparse endian annotations
Message-Id: <20080720234211.4c77f506.akpm@linux-foundation.org>
In-Reply-To: <1216341695.6029.133.camel@brick>
References: <1216341695.6029.133.camel@brick>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 17:41:35 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> fs/lockd/svcproc.c:115:11: warning: incorrect type in initializer (different base types)
> fs/lockd/svcproc.c:115:11:    expected int [signed] rc
> fs/lockd/svcproc.c:115:11:    got restricted __be32 [usertype] <noident>
> ... and so on...

Bruce handles lockd stuff.  Not that a reader of ./MAINTAINERS would
know this </hint>.
