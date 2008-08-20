Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbYHTAER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbYHTAER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYHTAD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:03:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbYHTAD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:03:57 -0400
Date: Tue, 19 Aug 2008 20:03:55 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] vt: kill tty->count usage (v2)
Message-ID: <20080820000354.GD7154@redhat.com>
References: <20080808213625.GK20355@redhat.com> <20080808222635.4fe52b51@lxorguk.ukuu.org.uk> <20080812145812.GH7154@redhat.com> <20080818181902.59ac763b@lxorguk.ukuu.org.uk> <20080818210414.GB7154@redhat.com> <20080819160318.26f70590@lxorguk.ukuu.org.uk> <20080819170317.GC7154@redhat.com> <20080819181443.2c1dbbf8@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819181443.2c1dbbf8@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > isn't too late for drivers that wait for the remaining data to be transmitted
> > such as amiserial and cyclades? Unless there's a plan to do it at
> > release_dev()?
> 
> Agreed: waiting for data to be transmitted is one thing, freeing resources
> another. We don't want to be freeing resources until the tty object is
> destructed. Also most drivers won't be able to block there as they will
> be using krefs to the tty and thus potentially destructing it from an IRQ
> handler.
sorry to ask again, but did you managed to make your stack of patches
available for download?

-- 
Aristeu

