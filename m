Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZEZU1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZEZU1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZEZU1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:27:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460AbZEZU1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:27:46 -0400
Date: Tue, 26 May 2009 13:27:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] Remove cred leftovers from sched.h
Message-Id: <20090526132730.5394d1bc.akpm@linux-foundation.org>
In-Reply-To: <20090526115953.GA4958@x200.localdomain>
References: <20090526115953.GA4958@x200.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 15:59:53 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> struct user_struct and functions which work with it do not belong to sched.h
> Remove cred.h inclusion from sched.h
> Add necessary headers where needed (cred.h, capability.h)
> 
> As result sched.h inclusion results in something like -6% stuff after
> preprocessing.
> 
> ...
>
>  140 files changed, 197 insertions(+), 156 deletions(-)

Someone's going to need to make all this apply to and work with the
appropriate kernel tree (and that's linux-next, not 2.6.30-rc7).

That person could be me, but I have a weeks worth of catchup to do
here.
