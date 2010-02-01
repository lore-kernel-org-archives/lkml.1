Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0BAUKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:10:20 -0500
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:51687 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754936Ab0BAUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:10:18 -0500
From: Frans Pop <elendil@planet.nl>
To: Joe Perches <joe@perches.com>
Subject: Re: [RFC] Fix unnecessary spaces before newlines in logging messages
Date: Mon, 1 Feb 2010 21:10:15 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <cover.1264967493.git.joe@perches.com> <201002012007.25498.elendil@planet.nl> <1265052929.25140.331.camel@Joe-Laptop.home>
In-Reply-To: <1265052929.25140.331.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002012110.16612.elendil@planet.nl>
X-OriginalArrivalTime: 01 Feb 2010 20:10:16.0779 (UTC) FILETIME=[923561B0:01CAA37A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Joe Perches wrote:
> I think it's useful, though like all of these cleanups,
> a low priority.  I suggest you submit a few through to
> various maintainers and see what happens.

Will do.

> (with false positives for asm and such)
> $ grep -rP --include=*.[ch] "\s+\\\n" * | wc -l
> 7339

I'm left with 2303 after cleaning out false positives (of which 1016 in 
staging...).

Cheers,
FJP
