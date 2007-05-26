Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbXEZFmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbXEZFmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 01:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXEZFmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 01:42:10 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbXEZFmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 01:42:09 -0400
Date: Fri, 25 May 2007 22:41:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Auke Kok <auke-jan.h.kok@intel.com>, Andy Whitcroft <apw@shadowen.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] scripts: Make cleanfile/cleanpatch warn about long
 lines
Message-Id: <20070525224124.5d0a310b.akpm@linux-foundation.org>
In-Reply-To: <200705260100.l4Q10e05030097@tazenda.hos.anvin.org>
References: <200705260100.l4Q10e05030097@tazenda.hos.anvin.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 17:58:26 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> Make the "cleanfile" and "cleanpatch" script warn about long lines,
> by default lines whose visual width exceeds 79 characters.
> 
> Per suggestion from Auke Kok.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> ---
>  scripts/cleanfile  |   54 ++++++++++++++++++++++++++++++++++++++++++++++-
>  scripts/cleanpatch |   58 +++++++++++++++++++++++++++++++++++++++++++++++++--

This functionality wholly duplicates the patch-sanity-checking script
which Andy, Randy and others are working on.

The plan is to merge that script into the tree and, once it's looking
reasonably accurate, we wire a copy of it up to the email lists so that it
autonags patch-senders over the usual trivial junk.  Think of it as an
akpm-over-SMTP server.
