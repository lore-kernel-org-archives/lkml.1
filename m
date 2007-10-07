Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbXJGQ7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbXJGQ7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbXJGQ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:59:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42661 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbXJGQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:59:45 -0400
Date: Sun, 7 Oct 2007 09:58:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: how to tell it multiple pte locks is OK?
Message-ID: <20071007095853.13a8755d@laptopd505.fenrus.org>
In-Reply-To: <47087D45.2010904@goop.org>
References: <47087D45.2010904@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Oct 2007 23:31:33 -0700

> I'm presume I'm the first person to try holding multiple pte locks at
> once, so there's no existing locking order for these locks.  I'm
> always traversing and locking the pagetable in virtual address order
> (and this seems like a sane-enough rule for anyone else who wants to
> hold multiple pte locks).

I'm not sure that's a valid assumption in light of things like sharing
pagetables between processes etc etc..
(granted, that one is out of tree right now but I still hope it'll go
in some day:)
