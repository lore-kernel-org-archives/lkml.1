Return-Path: <linux-kernel-owner+w=401wt.eu-S2992780AbXDDJZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992780AbXDDJZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992783AbXDDJZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:25:43 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:9393 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992780AbXDDJZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:25:42 -0400
Subject: Re: [PATCH 1/6] mm: scalable bdi statistics counters.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com
In-Reply-To: <E1HZ1fn-0005oT-00@dorka.pomaz.szeredi.hu>
References: <20070403144047.073283598@taijtu.programming.kicks-ass.net>
	 <20070403144224.227434440@taijtu.programming.kicks-ass.net>
	 <E1HZ1fn-0005oT-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 11:25:38 +0200
Message-Id: <1175678738.6483.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 11:20 +0200, Miklos Szeredi wrote:
> > Provide scalable per backing_dev_info statistics counters modeled on the ZVC
> > code.
> 
> Why do we need global_bdi_stat()?  It should give approximately the
> same numbers as global_page_state(), no?

For those counters that are shared, yes. However I find it not obvious
that all BDI counter will always be mirrored in the page stats, and I
actually use it in 6/6, which introduces counters that are not mirrored
in the page stats.



