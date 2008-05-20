Return-Path: <linux-kernel-owner+w=401wt.eu-S933107AbYETSqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbYETSqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbYETSpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:45:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42681 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758367AbYETSpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:45:46 -0400
Date: Tue, 20 May 2008 19:33:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, corbet@lwn.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
Message-ID: <20080520193314.061f0c24@core>
In-Reply-To: <20080520085830.22c99115@infradead.org>
References: <20080520528.793382059@firstfloor.org>
	<20080520152843.CF4181B4205@basil.firstfloor.org>
	<20080520085830.22c99115@infradead.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 08:58:30 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 20 May 2008 17:28:43 +0200 (CEST)
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > 
> > Add a new fops entry point to allow fasync without BKL. 
> 
> I (again) really don't like having another entry point for this...
> it'll stay around forever rather than doing this as one step and 
> move on.

Agreed entirely - all our unlocked_foo methods we got stuck with, all our
push down everyone cases we got most cases promptly fixed and the other
lock/unlocks show up clearly in grep and help embarass the
maintainer/author 8)
