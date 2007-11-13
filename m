Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbXKMKS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbXKMKS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbXKMKSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:18:49 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3340 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbXKMKSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:18:49 -0500
Date: Tue, 13 Nov 2007 10:18:58 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch.pl and no newline handling
Message-ID: <20071113101858.GD12003@shadowen.org>
References: <8bd0f97a0711121146w30b88cdcs8abf3f5b6bff2d14@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0711121146w30b88cdcs8abf3f5b6bff2d14@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 02:46:30PM -0500, Mike Frysinger wrote:
> the current checkpatch.pl does not reject new files that lack a
> newline, yet rejects patches that fix newlines in files ... quite the
> opposite of what we actually want

Nice.  Just what the world needs.  I wonder what the heck that format
means.  Obviously the "corrupt" check is wrong as a "\ No newline" line
is valid not corrupt.  Now when is "\ No newline" a good thing and when
a bad thing.  It _looks_ like it is 'bound' to the line before, and if
so then its pretty simple.

Bad:
> +moo
> \ No newline at end of file

Good:
> -moo
> \ No newline at end of file

/me goes read the source for diff.  Sigh.

Thanks for the report.

-apw
