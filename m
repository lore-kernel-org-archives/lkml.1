Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbXKEXhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbXKEXhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXKEXhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:37:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53462 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbXKEXhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:37:04 -0500
Date: Mon, 5 Nov 2007 15:35:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       haveblue@us.ibm.com
Subject: Re: [PATCH 25/27]
 r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts
Message-Id: <20071105153554.908846f9.akpm@linux-foundation.org>
In-Reply-To: <20071101230900.13469A0F@kernel>
References: <20071101230826.9A4F6E00@kernel>
	<20071101230900.13469A0F@kernel>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Nov 2007 16:09:00 -0700
Dave Hansen <haveblue@us.ibm.com> wrote:

> With the r/o bind mount patches, we can have as many
> spinlocks nested as there are CPUs on the system.
> Lockdep freaks out after 8.
> 
> So, create a new lockdep class of locks for the
> mnt_writer spinlocks, and initialize each of the
> cpu locks to be in a different class.
> 
> It should shut up warnings like this, while still
> allowing some of the lockdep goodness to remain:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.23-rc6 #6
> 

I added your signed-off-by: to this.

I wish you hadn't mucked up all those Subject:s
