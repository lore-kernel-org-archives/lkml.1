Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbZBDT6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbZBDT6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZBDT5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:57:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbZBDT5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:57:51 -0500
Date: Wed, 4 Feb 2009 11:57:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dean Nelson <dcn@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sgi-xp: fix writing past the end of kzalloc()'d space
 (v.2)
Message-Id: <20090204115721.74531d5c.akpm@linux-foundation.org>
In-Reply-To: <20090204183641.GA24632@sgi.com>
References: <20090203182338.GA1770@sgi.com>
	<20090203120147.dd079ffd.akpm@linux-foundation.org>
	<20090204183641.GA24632@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 12:36:41 -0600 Dean Nelson <dcn@sgi.com> wrote:

> Note that I'm using 'void *' instead of 'u8 *' to ->define recv_msg_slots.
> Currently they are equivalent in terms of the math, but 'void *' has the
> advantage of not needing to cast at all. Is this an appropriate choice?

I think so.  void* is a nice way of saying "here's a blob of bytes". 
It's a gcc extension to permit arithmetic on a void*, but we use that
one widely.

