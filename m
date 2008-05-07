Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbYEGE1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbYEGE1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYEGE1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:27:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbYEGE1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:27:06 -0400
Date: Tue, 6 May 2008 21:26:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>, David Miller <davem@davemloft.net>,
       tony@bakeyournoodle.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
Message-Id: <20080506212643.444b96db.akpm@linux-foundation.org>
In-Reply-To: <20080506212314.695daf98.akpm@linux-foundation.org>
References: <20080424043400.GS20457@bakeyournoodle.com>
	<20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<20080506145608.565b61bf.akpm@linux-foundation.org>
	<20080506210055.75e2f881@infradead.org>
	<20080506211233.f050fd41.akpm@linux-foundation.org>
	<20080506211552.6af7cecc@infradead.org>
	<20080506212314.695daf98.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 21:23:14 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> otcompletelyoh, perhaps we could generate a backtrace from within printk()
> itself for when it sees messages which have KERN_ERR or some other
> suitably-chosen (and probably configurable) facility level.

and if that is impractical, perhaps create a new printk facility
(KERN_TRACE?) which gets rewritten to KERN_ERR, but tells printk()
to generate a trace.

Do we really need the file-n-line info?
