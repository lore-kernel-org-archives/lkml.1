Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbXFDUPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbXFDUPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759769AbXFDUPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:15:36 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:35297 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760228AbXFDUPf (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:15:35 -0400
Date: Mon, 4 Jun 2007 16:15:33 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Ingo Molnar <mingo@elte.hu>
cc: Matt Mackall <mpm@selenic.com>, Rusty Russell <rusty@rustcorp.com.au>,
       akpm@linux-foundation.org, Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
In-Reply-To: <20070604181151.GA1745@elte.hu>
Message-ID: <Line.LNX.4.64.0706041613310.13341@d.namei>
References: <20070604173710.GR11166@waste.org> <20070604181151.GA1745@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Ingo Molnar wrote:

> perhaps lguest does something unusual when it idles? Does it fiddle 
> sched_clock() in any way?

One of the lguest processes calls nice(2), which seems like a long shot, 
but also not impossibly related.  (Note that newer patches in the lguest 
queue remove this, so it'll depend on exactly which patches you have 
applied).


- James
-- 
James Morris
<jmorris@namei.org>
