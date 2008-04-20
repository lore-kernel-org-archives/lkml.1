Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYDTVqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYDTVqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYDTVpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 17:45:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbYDTVpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 17:45:51 -0400
Date: Sun, 20 Apr 2008 14:45:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: andi@firstfloor.org, dhazelton@enter.net, bunk@kernel.org,
       alan@lxorguk.ukuu.org.uk, shawn.bohrer@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: x86: 4kstacks default
Message-Id: <20080420144512.d28e5bd2.akpm@linux-foundation.org>
In-Reply-To: <20080420114845.77bf3fed@laptopd505.fenrus.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080420104444.GI1595@cs181133002.pp.htv.fi>
	<87y778aezh.fsf@basil.nowhere.org>
	<200804201144.33308.dhazelton@enter.net>
	<480B7CB2.3080002@firstfloor.org>
	<20080420114845.77bf3fed@laptopd505.fenrus.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 20 Apr 2008 11:48:45 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> We don't have effective physical address based reclaim yet for higher order allocs.

Lumpy reclaim is supposed to be exactly that.
