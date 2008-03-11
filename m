Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYCKRYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYCKRYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYCKRXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:23:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:49742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbYCKRXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:23:53 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Date: Tue, 11 Mar 2008 13:23:11 -0400
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       devzero@web.de, linux-kernel@vger.kernel.org, rick@vanrein.org
References: <182234194@web.de> <47D56DD3.8060108@zytor.com> <200803101959.47202.dl9pf@gmx.de>
In-Reply-To: <200803101959.47202.dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111323.11524.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +How to deal with bad memory e.g. reported by memtest86+ ?
> +#########################################################
> +
> +There are three possibilities I know of:

I find that sometimes memory problems go away when
I simply remove and then re-insert the same DIMMs.
Maybe that is the thing to try first.

-Len

> +1) Buy new memory (best!)
> +
> +2) Try to exchange the memory if you have spare-parts
> +
> +3) Use BadRAM or memmap
> +
> +This Howto is about number 3) .
