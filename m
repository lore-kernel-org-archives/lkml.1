Return-Path: <linux-kernel-owner+w=401wt.eu-S1761632AbYBLHtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632AbYBLHtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYBLHtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:49:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757403AbYBLHtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:49:02 -0500
Date: Mon, 11 Feb 2008 23:47:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: tidy up follow_hugetlb_page() and get_user_pages()
Message-Id: <20080211234720.972574ea.akpm@linux-foundation.org>
In-Reply-To: <20080212052840.GA3942@kernel.sg>
References: <20080212052840.GA3942@kernel.sg>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 13:28:40 +0800 Eugene Teo <eugeneteo@kernel.sg> wrote:

> This patch extends Jonathan Corbet's patch to avoid buffer overflows in
> get_user_pages(). It cleans up follow_hugetlb_page(), and get_user_pages() so
> that it is easier to read. It also makes sure that len and vma are validated.

We'd prefer that the functional change not be bundled with a (large) cleanup, please.
