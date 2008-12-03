Return-Path: <linux-kernel-owner+w=401wt.eu-S1760320AbYLCUnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320AbYLCUnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbYLCUmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:42:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760606AbYLCUmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:42:16 -0500
Date: Wed, 3 Dec 2008 12:41:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Yet more ARM breakage in linux-next
Message-Id: <20081203124109.79f8f15b.akpm@linux-foundation.org>
In-Reply-To: <20081203192905.GA12502@flint.arm.linux.org.uk>
References: <20081203192905.GA12502@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 19:29:05 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> This seems to be causing lots of ARM breakage:
> 
> lib/find_next_bit.c:183: error: implicit declaration of function '__fls'
> 
> Whoever's responsible,

git-blame?

> please fix this ASAP so I can see whether my fixes
> I merged on Monday fix the previous set of ARM build errors in linux-next.

commit b032dfc80921daa9c957810fb2e2ff253aaf2ac4
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Dec 3 11:16:59 2008 +1100

    bitmap:find_last_bit

