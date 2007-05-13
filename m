Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbXEMSUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbXEMSUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbXEMSUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:20:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33492 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbXEMSUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:20:41 -0400
Date: Sun, 13 May 2007 19:20:35 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dan Aloni <da-x@monatomic.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
Message-ID: <20070513182035.GA10207@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Dan Aloni <da-x@monatomic.org>,
	Linux Kernel List <linux-kernel@vger.kernel.org>
References: <20070513132517.GA14038@localdomain> <20070513092352.18cd80de@freepuppy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513092352.18cd80de@freepuppy>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 09:23:52AM -0700, Stephen Hemminger wrote:
> On Sun, 13 May 2007 16:25:17 +0300
> Dan Aloni <da-x@monatomic.org> wrote:
> 
> > Kernel developers might find it useful for quickly getting out from some 
> > rough debugging scenarios.
> > 
> > Signed-off-by: Dan Aloni <da-x@monatomic.org>
> > 
> 
> There is already the modprobe blacklist ability in user space.

doesn't really help if hotplug loads a broken module before you're getting
a login prompt.  So while this is a bit of a hack I'm all in favour of this.
(Especially as I got hit by this issue again yesterday)
