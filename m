Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbYE0J2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbYE0J2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 05:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYE0J2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 05:28:05 -0400
Received: from styx.suse.cz ([82.119.242.94]:55034 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754183AbYE0J2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 05:28:04 -0400
Subject: Re: Why is the rewritten ramdisk driver called brd instad of rd
From: Petr Tesarik <ptesarik@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: torvalds@osdl.org, npiggin@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080321130552.GA28274@lst.de>
References: <20080321130552.GA28274@lst.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Tue, 27 May 2008 11:28:00 +0200
Message-Id: <1211880480.29836.11.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 14:05 +0100, Christoph Hellwig wrote:
> Any reason why the rewritten ramdisk driver has a new name?  It's for
> all matters an inplace replacement of the old rd driver so it should
> be called rd.c / rd.ko to not confused instaler/developers/etc.

I think it's because the old rd played some dirty tricks with the page
cache, while the reworked one is a straightforward implementation of a
normal _b_lock device -> hence the "b".

No guarantee of correctness.

Petr Tesarik

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
