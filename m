Return-Path: <linux-kernel-owner+w=401wt.eu-S1760528AbXH2TIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528AbXH2TIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbXH2TI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:08:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34954 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbXH2TIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:08:24 -0400
Date: Wed, 29 Aug 2007 20:08:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, dhowells@redhat.com
Subject: Re: [patch 2/4] Use pathput in a few more places
Message-ID: <20070829190823.GB28028@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
	John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
	Erez Zadok <ezk@cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>, dhowells@redhat.com
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de> <20070808193209.GA31354@infradead.org> <20070810142208.827949199@suse.de> <20070810143846.930027497@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810143846.930027497@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 04:22:10PM +0200, Andreas Gruenbacher wrote:
> afs_mntpt_follow_link() actually does mntput before dput, which is wrong.

Please send a fix to Dave to fix this for 2.6.24 and stable even without
introducing pathput just yet.

The actual patch is fine.
