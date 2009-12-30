Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZL3Ted@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZL3Ted (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZL3Tec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:34:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125AbZL3Tec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:34:32 -0500
Date: Wed, 30 Dec 2009 11:33:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Bottomley <James.Bottomley@suse.de>
cc: Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] libsrp: fix compile failure
In-Reply-To: <1262200866.2749.226.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
References: <1262200866.2749.226.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Dec 2009, James Bottomley wrote:
>
> The fix is simple, just add the include, but how did this happen?  This 
> change, introduced at -rc2, hardly looks like a bug fix, and it clearly 
> didn't go through linux-next, which would have picked up this compile 
> failure (it only occurs on ppc because of the ibm virtual scsi target).

It came through Andrew - and apparently parts of Andrews chain weren't in 
next. Don't know why.

> James

Sign-off?

		Linus
