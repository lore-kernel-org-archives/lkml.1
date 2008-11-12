Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbYKLBov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbYKLBov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYKLBom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:44:42 -0500
Received: from ozlabs.org ([203.10.76.45]:34963 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYKLBom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:44:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] Allocate module.ref array dynamically
Date: Wed, 12 Nov 2008 12:14:32 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Takashi Iwai <tiwai@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <491A01E2.2010701@cosmosbay.com>
In-Reply-To: <491A01E2.2010701@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121214.33150.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008 08:36:26 Eric Dumazet wrote:
> I believe Mike Travis has a better patch for this problem, partly using new
> percpu allocator.

Actually, I think this in in Christoph's hands now.  He's been wrangling with 
getting us a real per-cpu allocator.

There's something in linux-next, but I'm not sure of the status. Christoph, is 
this anticipated to make the next merge window, or am I best off merging a 
patch like Eric's for the moment?

Thanks,
Rusty.
