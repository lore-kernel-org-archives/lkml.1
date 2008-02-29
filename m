Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbYB2Gum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbYB2Gum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYB2Gue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:50:34 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbYB2Gud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:50:33 -0500
Date: Thu, 28 Feb 2008 22:49:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bill Nottingham <notting@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC, BAD IDEA] /proc/tty/console
Message-Id: <20080228224923.fbbd97dc.akpm@linux-foundation.org>
In-Reply-To: <20080227181857.GA3137@nostromo.devel.redhat.com>
References: <20080227181857.GA3137@nostromo.devel.redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 13:18:57 -0500 Bill Nottingham <notting@redhat.com> wrote:

> The attached patch adds /proc/tty/console. The contents of it are
> simply a description of the current drivers attached to /dev/console.
> For example, a boot with 'console=ttyS3,115200n1 console=tty0' would
> yield:
> 
> # cat /proc/tty/console
> unknown             /dev/tty0
> serial              /dev/ttyS3

I must say that the what-consoles-are-registered problem makes my head spin
sometimes too.  Seems a worthy objective.

However I think that a bunch of plain old printks which are emitted when a
console is added or removed would suffice?

We should display each console's CON_foo flags too.
