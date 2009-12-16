Return-Path: <linux-kernel-owner+w=401wt.eu-S934574AbZLPC1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574AbZLPC1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934557AbZLPC1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:27:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48439 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934556AbZLPC1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:27:50 -0500
Date: Wed, 16 Dec 2009 11:27:39 +0900 (JST)
Message-Id: <20091216.112739.104046780.d.hatayama@jp.fujitsu.com>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Subject: Re: [RFC, PATCH 3/4] elf_core_dump(): make offset calculation and
 writing processes explicit
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
In-Reply-To: <87ocm0wct8.fsf@basil.nowhere.org>
References: <20091215.114137.104035145.d.hatayama@jp.fujitsu.com>
	<87ocm0wct8.fsf@basil.nowhere.org>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com> writes:
> >
> > However, the clause 1. is not always possible, since one
> > cannot assume that dump_seek() function always supports
> > the seek in the minus direction. Consider no_llseek.
> 
> Not even forward seek is always supported, consider core dumping
> to a pipe.
> 
> -Andi

I may need to use backward seeking here, not forward. So, I stressed
here for the backward one.

Thanks.
