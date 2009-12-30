Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZL3T4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZL3T4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZL3T4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:56:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbZL3T4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:56:06 -0500
Subject: Re: [PATCH] libsrp: fix compile failure
From: James Bottomley <James.Bottomley@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
References: <1262200866.2749.226.camel@mulgrave.site>
	 <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 13:55:57 -0600
Message-Id: <1262202957.2749.241.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 11:33 -0800, Linus Torvalds wrote:
> 
> On Wed, 30 Dec 2009, James Bottomley wrote:
> >
> > The fix is simple, just add the include, but how did this happen?  This 
> > change, introduced at -rc2, hardly looks like a bug fix, and it clearly 
> > didn't go through linux-next, which would have picked up this compile 
> > failure (it only occurs on ppc because of the ibm virtual scsi target).
> 
> It came through Andrew - and apparently parts of Andrews chain weren't in 
> next. Don't know why.
> 
> > James
> 
> Sign-off?

Sorry, forgot ... 

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

James


