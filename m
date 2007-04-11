Return-Path: <linux-kernel-owner+w=401wt.eu-S1750844AbXDKKGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750844AbXDKKGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXDKKGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:06:19 -0400
Received: from amsfep15-int.chello.nl ([62.179.120.10]:54212 "EHLO
	amsfep15-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbXDKKGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:06:19 -0400
Subject: Re: Why kmem_cache_free occupy CPU for more than 10 seconds?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: Zhao Forrest <forrest.zhao@gmail.com>, penberg@cs.helsinki.fi,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070411025305.b9131062.pj@sgi.com>
References: <ac8af0be0704102317q50fe72b1m9e4825a769a63963@mail.gmail.com>
	 <84144f020704102353r7dcc3538u2e34237d3496630e@mail.gmail.com>
	 <ac8af0be0704110214qdca2ee9t3b44a17341e53730@mail.gmail.com>
	 <20070411025305.b9131062.pj@sgi.com>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 12:06:16 +0200
Message-Id: <1176285976.6893.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 02:53 -0700, Paul Jackson wrote:
> I'm confused - which end of ths stack is up?
> 
> cpuset_exit doesn't call do_exit, rather it's the other
> way around.  But put_files_struct doesn't call do_exit,
> rather do_exit calls __exit_files calls put_files_struct.

I'm guessing its x86_64 which generates crap traces.

