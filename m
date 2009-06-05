Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZFETYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZFETYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZFETYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:24:44 -0400
Received: from verein.lst.de ([213.95.11.210]:56661 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbZFETYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:24:43 -0400
Date: Fri, 5 Jun 2009 21:22:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Christoph Hellwig <hch@lst.de>, Olaf Weber <olaf@sgi.com>,
       mingo@elte.hu, rusty@rustcorp.com.au, davem@davemloft.net
Subject: Re: [this_cpu_xx 07/11] xfs_icsb_modify_counters does not need "cpu" variable
Message-ID: <20090605192206.GA23547@lst.de>
References: <20090605191819.376530498@gentwo.org> <20090605191851.584051004@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605191851.584051004@gentwo.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.734 () BAYES_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 03:18:26PM -0400, cl@linux-foundation.org wrote:
> The xfs_icsb_modify_counters() function no longer needs the cpu variable
> if we use this_cpu_ptr() and we can get rid of get/put_cpu().

Looks good to me.  While you're at it you might also remove the
superflous cast of the this_cpu_ptr return value.


Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, any reason this_cpu_ptr doesn't do the preempt_disable itself
and has something paired to reverse it?

