Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbXDDVA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbXDDVA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXDDVAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:00:15 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56190 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXDDVAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:00:13 -0400
Date: Wed, 4 Apr 2007 14:00:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Bittermann <t.bittermann@online.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.21-rc5] kernel/time.c: add missing symbol exports
Message-Id: <20070404140007.15aa1893.akpm@linux-foundation.org>
In-Reply-To: <461408A6.5010005@online.de>
References: <461408A6.5010005@online.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 22:20:54 +0200
Thomas Bittermann <t.bittermann@online.de> wrote:

> This patch adds 2 missing symbol exports:
> 
> jiffies_to_timeval
> timeval_to_jiffies

I don't see any in-tree code which needs these symbols?

The exports might make sense from a consistency POV, but I'd be interested
in knowing what motivated this change?
