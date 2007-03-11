Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbXCKDkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbXCKDkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbXCKDkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:40:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35241 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932810AbXCKDkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:40:18 -0500
Date: Sat, 10 Mar 2007 19:39:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: RSDL-mm 0.28
Message-Id: <20070310193954.58389077.akpm@linux-foundation.org>
In-Reply-To: <200703111459.28806.kernel@kolivas.org>
References: <20070311013506.GD10459@waste.org>
	<8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com>
	<20070310191614.5ac3cf4b.akpm@linux-foundation.org>
	<200703111459.28806.kernel@kolivas.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 11 Mar 2007 14:59:28 +1100 Con Kolivas <kernel@kolivas.org> wrote:
> > Bottom line: we've had a _lot_ of problems with the new yield() semantics.
> > We effectively broke back-compatibility by changing its behaviour a lot,
> > and we can't really turn around and blame application developers for that.
> 
> So... I would take it that's a yes for a recommendation with respect to 
> implementing a new yield() ? A new scheduler is as good a time as any to do 
> it.

I guess so.  We'd, err, need to gather Ingo's input ;)

Perhaps a suitable way of doing this would be to characterise then emulate
the 2.4 behaviour.  As long as it turns out to be vaguely sensible.
