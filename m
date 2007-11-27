Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbXK0Tfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbXK0Tfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 14:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbXK0Tf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 14:35:28 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3067 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXK0Tf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:35:27 -0500
Subject: Re: [PATCH 2/2] ide-scsi: use print_hex_dump from <linux/kernel.h>
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Cheng <crquan@gmail.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20071127013119.d12b7791.akpm@linux-foundation.org>
References: <1196061373-6394-1-git-send-email-crquan@gmail.com>
	 <20071127013119.d12b7791.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 11:34:16 -0800
Message-Id: <1196192056.31590.54.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-27 at 01:31 -0800, Andrew Morton wrote:
> Either way, perhaps a simple little front-end to print_hex_dump() is called
> for.

Perhaps an even simpler generic version of what's
now used in crypto/tcrypt.c:

void print_cont_hex_dump_bytes(const void *buf, size_t len)
{
	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE,
		       16, 1, buf, len, false);
}

or just use print_hex_dump_bytes.


