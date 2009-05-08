Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbZEHPi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbZEHPi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZEHPiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:38:46 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:60966 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753124AbZEHPip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:38:45 -0400
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 11:38:45 EDT
Date: Fri, 8 May 2009 11:29:16 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, gorcunov@openvz.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rientjes@google.com
Subject: Re: [PATCH 1/2] mm: Introduce GFP_PANIC for early-boot allocations
In-Reply-To: <1241795428.28600.60.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0905081128241.26361@qirst.com>
References: <1241795428.28600.60.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Pekka Enberg wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> This patch introduces a GFP_PANIC flag that can be used as an annotation
> that an early-boot call to kmalloc() or alloc_pages() is expected to
> never fail.

I think the early-boot requirement needs to be dropped. Make this safe to
be used at anytime.
