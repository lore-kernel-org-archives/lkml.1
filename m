Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbZLEAIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbZLEAIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932581AbZLEAIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:08:40 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37665 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbZLEAIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:08:39 -0500
Date: Fri, 4 Dec 2009 17:08:45 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Emese Revfy <re.emese@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/31] Constify struct address_space_operations for
	2.6.32 v1
Message-ID: <20091205000845.GB9482@parisc-linux.org>
References: <4B198670.2000406@gmail.com> <4B198849.1060909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B198849.1060909@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 11:08:09PM +0100, Emese Revfy wrote:
>  struct address_space_operations {
> -	int (*writepage)(struct page *page, struct writeback_control *wbc);
> -	int (*readpage)(struct file *, struct page *);
> -	void (*sync_page)(struct page *);
> +	int (* const writepage)(struct page *page, struct writeback_control *wbc);
> +	int (* const readpage)(struct file *, struct page *);
> +	void (* const sync_page)(struct page *);

Umm.  What effect does this have?  Aren't functions implicitly constant?
What changes as a result of this patch?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
