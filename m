Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbZD0Ruj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbZD0Ruj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZD0Ru3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:50:29 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:33283 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbZD0Ru2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:50:28 -0400
Date: Mon, 27 Apr 2009 13:39:06 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Bart <mmx@riz.pl>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13112] Oops in drain_array
In-Reply-To: <Pine.LNX.4.64.0904271849590.2455@galaxy.riz.pl>
Message-ID: <alpine.DEB.1.10.0904271337450.31916@qirst.com>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>  <egHshlwQQFE.A.KjC.JpE9JB@chimera>  <alpine.DEB.2.00.0904261314430.18988@chino.kir.corp.google.com> <84144f020904270152o6567e84cj914934120315bf90@mail.gmail.com> <alpine.DEB.1.10.0904271000200.16119@qirst.com>
 <Pine.LNX.4.64.0904271849590.2455@galaxy.riz.pl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Bart wrote:

> Apr 27 16:57:30 fs kernel: [   96.446708] slab error in verify_redzone_free():
> cache `size-128': memory outside object was overwritten

Allright so a write after or before a 128 byte kmalloc object. Can
you switch to the SLUB allocator so that we can get memory dumps of
the corruption which will help to diagnose this further?

