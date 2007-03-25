Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbXCYXpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbXCYXpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 19:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbXCYXpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 19:45:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36107 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975AbXCYXpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 19:45:45 -0400
Date: Sun, 25 Mar 2007 15:45:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] add file position info to proc
Message-Id: <20070325154541.6dcbd291.akpm@linux-foundation.org>
In-Reply-To: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu>
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 23:04:09 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> This patch adds support for finding out the current file position,
> open flags and possibly other info in the future.
> 
> These new entries are added:
> 
>   /proc/PID/fdinfo/FD
>   /proc/PID/task/TID/fdinfo/FD
> 
> For each fd the information is provided in the following format:
> 
> pos:	1234
> flags:	0100002

I've seen the idea mentioned once or twice, but not with any great
enthusiasm.  Why does Linux want this feature?
