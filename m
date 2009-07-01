Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZGAR3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZGAR3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbZGAR2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:28:40 -0400
Received: from kroah.org ([198.145.64.141]:55706 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbZGAR2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:28:39 -0400
Date: Wed, 1 Jul 2009 10:26:45 -0700
From: Greg KH <greg@kroah.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Alasdair G Kergon <agk@redhat.com>, akpm@linux-foundation.org,
       Jonathan Brassow <jbrassow@redhat.com>, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Stable-review] [patch 098/108] dm exception store: fix
 exstore lookup to be case insensitive
Message-ID: <20090701172645.GB15542@kroah.com>
References: <20090701002249.937782934@mini.kroah.org>
 <20090701002442.471525145@mini.kroah.org>
 <4A4B0C36.4060506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4B0C36.4060506@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 09:11:50AM +0200, Milan Broz wrote:
> Greg KH wrote:
> > 2.6.30-stable review patch.  If anyone has any objections, please let us know.
> > commit f6bd4eb73cdf2a5bf954e497972842f39cabb7e3 upstream.
> 
> NACK.
> 
> this patch must be applied together with commit
>  874d2f61d31e596c36af7732dc1b3aa2dc233824  dm exception store: really fix type lookup
> 
> or removed from stable because in this form will introduce regression.

Yes, I was waiting for the second patch to go into Linus's tree, and
it's now there.  So I'll queue it up as well.

thanks,

greg k-h
