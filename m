Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbXHBDiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbXHBDiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 23:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXHBDh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 23:37:58 -0400
Received: from mail.suse.de ([195.135.220.2]:49859 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbXHBDh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 23:37:58 -0400
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <htejun@gmail.com>
Date: Thu, 2 Aug 2007 13:37:42 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18097.20870.834262.405375@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 013 of 35] Don't update bi_hw_*_size if we aren't going to merge.
In-Reply-To: message from Tejun Heo on Thursday August 2
References: <20070731112539.22428.patches@notabene>
	<1070731021655.25270@suse.de>
	<20070801155753.GF13674@htj.dyndns.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 2, htejun@gmail.com wrote:
> On Tue, Jul 31, 2007 at 12:16:55PM +1000, NeilBrown wrote:
> > 
> > ll_merge_requests_fn can update bi_hw_*_size in one case where we end
> > up not merging.  This is wrong.
> > 
> > Signed-off-by: Neil Brown <neilb@suse.de>
> 
> As this is a bug fix, I think it would better to bump this to the top
> of the series such that it can be pushed into mainline.

Good point.  I'll do that, thanks.

NeilBrown
