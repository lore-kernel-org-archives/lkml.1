Return-Path: <linux-kernel-owner+w=401wt.eu-S934166AbYBNAAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166AbYBNAAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762427AbYBNAAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:00:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51118 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760434AbYBNAAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:00:35 -0500
Date: Wed, 13 Feb 2008 15:59:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: torvalds@linux-foundation.org, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: implement printk_buf overflow warning
Message-Id: <20080213155954.c1d0b6ee.akpm@linux-foundation.org>
In-Reply-To: <47B2B250.8020209@gmail.com>
References: <47B2B250.8020209@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 18:03:12 +0900
Tejun Heo <htejun@gmail.com> wrote:

> printk silently truncates messages longer than 1024 - 1 bytes.
> Implement overflow detection and append "$PRINTK_BUF_OVERFLOW$\n" to
> truncated messages.

I don't think I've ever heard of anyone managing to overflow the printk
buffer and it's hard to imagine how a sane person could manage to do this.

I assume this is happening because of changes in your other patchset, and
that this change is hence associated with those changes and should probably
be a part of the same patch series?
