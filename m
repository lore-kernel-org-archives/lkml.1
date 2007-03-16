Return-Path: <linux-kernel-owner+w=401wt.eu-S965919AbXCPUyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965919AbXCPUyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965924AbXCPUyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:54:37 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35588 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965920AbXCPUyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:54:36 -0400
Date: Fri, 16 Mar 2007 12:54:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/5] revoke: core code
Message-Id: <20070316125421.ea2ae3bd.akpm@linux-foundation.org>
In-Reply-To: <84144f020703161337o3a6519cfn34d4b2620062264d@mail.gmail.com>
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
	<20070315173438.efadd514.akpm@linux-foundation.org>
	<84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
	<20070316032624.c6db84fc.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703161331580.21300@sbz-30.cs.Helsinki.FI>
	<20070316042600.3e1bd424.akpm@linux-foundation.org>
	<84144f020703161337o3a6519cfn34d4b2620062264d@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 22:37:57 +0200 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> What we could do is add a "I am revoked" flag to struct file which
> blocks any future ->readpage, ->readpages, and ->direct_IO on the
> file. Alternatively, we could change the ->f_mapping to point to an
> address space that has "revoked address space" operations. Hmm.

iirc, that was part of the rationale for the introduction of f_mapping.

I'll cc he-who-never-replies, who did that work.
