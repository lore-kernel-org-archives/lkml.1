Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZEVNjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZEVNjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 09:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbZEVNiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 09:38:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42253 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756917AbZEVNiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 09:38:54 -0400
Date: Fri, 22 May 2009 14:39:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Larry H." <research@subreption.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
Message-ID: <20090522143914.2019dd47@lxorguk.ukuu.org.uk>
In-Reply-To: <20090522113809.GB13971@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com>
	<4A15A8C7.2030505@redhat.com>
	<20090522073436.GA3612@elte.hu>
	<20090522113809.GB13971@oblivion.subreption.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > performance point of view: we _dont_ want to clear the full stack 
> > page for every kernel thread exiting.
> 
> Burning the stack there is beyond overkill.

Yet most of our historic leaks have been padding bytes in stack based
structures. Your position seems very inconsistent.
