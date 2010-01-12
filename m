Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661Ab0ALISy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0ALISy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870Ab0ALISx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:18:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544Ab0ALISx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:18:53 -0500
Date: Tue, 12 Jan 2010 00:16:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mhiramat@redhat.com,
       xiyou.wangcong@gmail.com, andi@firstfloor.org, jdike@addtoit.com,
       tony.luck@intel.com
Subject: Re: [RESEND][mmotm][PATCH v2, 0/5] elf coredump: Add extended
 numbering support
Message-Id: <20100112001647.3b992391.akpm@linux-foundation.org>
In-Reply-To: <20100112.170503.112616928.d.hatayama@jp.fujitsu.com>
References: <20100107162928.1d6eba76.akpm@linux-foundation.org>
	<20100112.121232.189721840.d.hatayama@jp.fujitsu.com>
	<20100111192418.5cd8a554.akpm@linux-foundation.org>
	<20100112.170503.112616928.d.hatayama@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 17:05:03 +0900 (JST) Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com> wrote:

> My concern is possibility of dump_seek()'s very short and general
> naming wasting public name space and colliding other global names.  My
> idea is, for example, to rename it coredump_dump_seek().

OK.  Yes, that would be a bit nicer.  I'm sure we have lots more
inappropriately named globals than that though.
