Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZEDTCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZEDTCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZEDTBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:01:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbZEDTBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:01:54 -0400
Date: Mon, 4 May 2009 11:53:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: gorcunov@gmail.com, mingo@elte.hu, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, riel@redhat.com,
       rientjes@google.com, xemul@openvz.org
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-Id: <20090504115335.9bc08587.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0905040940490.9553@qirst.com>
References: <20090504122740.GH4173@lenovo>
	<20090504131311.GA23330@elte.hu>
	<20090504131638.GJ4173@lenovo>
	<alpine.DEB.1.10.0905040940490.9553@qirst.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 09:47:45 -0400 (EDT)
Christoph Lameter <cl@linux.com> wrote:

> 
> 
> Could you try to avoid consuming another GFP flag? __GFP_BITS_SHIFT is
> used elsewhere to figure out where to put miscellanous flags into the gfp
> mask. This is pretty limited right now and so the patch does work.

hm, yes, there are seven bits left.

afaict bit 3 (0x08) is unused?

Is __GFP_PANIC very useful?  I expect it will permit a very small code
saving at a relatively small number of callsites, all of which are
__init anyway?

