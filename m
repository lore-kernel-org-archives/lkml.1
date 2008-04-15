Return-Path: <linux-kernel-owner+w=401wt.eu-S1761373AbYDOKph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373AbYDOKph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 06:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYDOKp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 06:45:29 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:37470 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYDOKp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:45:29 -0400
Date: Tue, 15 Apr 2008 12:45:07 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, alan@redhat.com, borntraeger@de.ibm.com,
       peter.oberparleiter@de.ibm.com, schwidefsky@de.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + s390-tty-prepare-for-put_char-to-return-success-fail.patch
	added to -mm tree
Message-ID: <20080415104507.GA18307@osiris.boeblingen.de.ibm.com>
References: <200804150204.m3F24GdU005600@imap1.linux-foundation.org> <20080415072117.GA4177@osiris.boeblingen.de.ibm.com> <20080415111101.41b6e9e3@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415111101.41b6e9e3@core>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 11:11:01AM +0100, Alan Cox wrote:
> > is allowed or not (1 means yes). Somebody told me that the put_char routine
> > will only be called from schedulable context, which now doesn't seem to be
> > true?!
> 
> It isnt true.
> 
> > For the console functions we pass indeed 0 to __sclp_vt220_write since printk
> > may be called within any context. Is that also true for the tty put_char
> > routine?
> 
> Yes, but failing a put_char is perfectly acceptable.

Ok, thanks for pointing this out! We are going to fix this as soon as your
patch is merged, so we can avoid further merge conflicts.
I assume your patch is for 2.6.26?
