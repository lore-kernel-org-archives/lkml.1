Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbZGWQWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbZGWQWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZGWQWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:22:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbZGWQWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:22:07 -0400
Date: Thu, 23 Jul 2009 18:18:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] move binfmt filed to signal_struct
Message-ID: <20090723161806.GA5690@redhat.com>
References: <4A56FEF7.80207@ct.jp.nec.com> <20090722132302.a9889eb3.akpm@linux-foundation.org> <20090722220353.88B2A67B6E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722220353.88B2A67B6E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Roland McGrath wrote:
>
> > > Because the binfmt is not different between threads in the same process,
> > > it can be moved from task_struct to signal_struct.
> >
> > Seems like a logical cleanup to me.
>
> IMHO binfmt belongs in mm_struct.

Ah, agreed.

Hiroshi, what do you think?

Oleg.

