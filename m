Return-Path: <linux-kernel-owner+w=401wt.eu-S1763611AbYEUFeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763611AbYEUFeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 01:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbYEUFeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 01:34:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbYEUFeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 01:34:13 -0400
Date: Tue, 20 May 2008 22:34:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: completely lost as to what to do, or where to look.
Message-Id: <20080520223410.9a8f200d.akpm@linux-foundation.org>
In-Reply-To: <dd18b0c30805202110x7c412b3bq523f91d968072482@mail.gmail.com>
References: <dd18b0c30805202110x7c412b3bq523f91d968072482@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 04:10:16 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:

> Hello; I'm lost as to where to look in the kernel, as to why I'm
> receiving a black screen with startx
> DRI seems to be fine, I'm noticing a sema_init but am not sure if this
> is the cause of the blackness.
> any direction as to where I might look would be helpful.

Kernel version?

A git-bisect should get you down the the offending commit within an
hour or three.  http://www.kernel.org/doc/local/git-quick.html has some
instructions.

But if you're on 2.6.26-rcX, be sure to use the very latest - a pile of
bad DRI code got reverted recently.  This morning, I think.
