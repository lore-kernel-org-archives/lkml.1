Return-Path: <linux-kernel-owner+w=401wt.eu-S935191AbYBWINA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935191AbYBWINA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbYBWIIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:08:40 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932607AbYBWIIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:37 -0500
Date: Sat, 23 Feb 2008 00:05:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amiserial: Prepare for locking relaxation in caller.
Message-Id: <20080223000525.19ed29ba.akpm@linux-foundation.org>
In-Reply-To: <20080220201101.6fff0c59@core>
References: <20080220201101.6fff0c59@core>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 20:11:01 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> 
> Just wrap this one in a lock_kernel. As I understand it there is no M68K
> SMP anyway.
> 

I assume that all the bkl/locking patches are prerequisites for
tty-bkl-pushdown.patch, and that they don't depend upon
tty-bkl-pushdown.patch?
