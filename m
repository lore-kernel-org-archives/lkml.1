Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbYB0E6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbYB0E6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYB0E6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:58:09 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2936 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbYB0E6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:58:08 -0500
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline
	__attribute__((format (printf,x,y) to statement expression macros
From: Joe Perches <joe@perches.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org
In-Reply-To: <20080227041316.GA23188@parisc-linux.org>
References: <1204081722.19319.405.camel@localhost>
	 <1204084947.19319.411.camel@localhost>
	 <20080227041316.GA23188@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 20:55:34 -0800
Message-Id: <1204088134.19319.420.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-26 at 21:13 -0700, Matthew Wilcox wrote:
> That's very interesting.  It's only 64 bytes, but still, it's not
> supposed to have any different effect.

Especially because __simple_attr_check_format is not even used
or called in an x86 defconfig.  It's powerpc/cell specific.

> Could you distill a test case for the GCC folks

I'll play around with it.


